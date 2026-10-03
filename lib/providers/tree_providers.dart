import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../core/models/enums.dart';
import '../data/db/app_database.dart';
import '../data/services/notification_service.dart';
import 'core_providers.dart';

// ── In-memory tree state (FR-03/04/05) ────────────────────────────────
class TreeState {
  final List<Node> nodes;
  final Map<int, int> visitCounts;
  const TreeState(this.nodes, {this.visitCounts = const {}});

  Map<int?, List<Node>> get byParent {
    final m = <int?, List<Node>>{};
    for (final n in nodes) {
      (m[n.parentId] ??= []).add(n);
    }
    for (final list in m.values) {
      list.sort((a, b) {
        final c = a.sortIndex.compareTo(b.sortIndex);
        return c != 0 ? c : a.id.compareTo(b.id);
      });
    }
    return m;
  }

  List<Node> childrenOf(int? parentId) => byParent[parentId] ?? const [];
  List<Node> get rootTabs => childrenOf(null);

  List<Node> breadcrumbOf(int id) {
    final byId = {for (final n in nodes) n.id: n};
    final path = <Node>[];
    var cur = byId[id];
    while (cur != null) {
      path.insert(0, cur);
      cur = cur.parentId == null ? null : byId[cur.parentId];
    }
    return path;
  }

  List<int> descendantIds(int id) {
    final m = byParent;
    final out = <int>[];
    void walk(int parent) {
      for (final c in m[parent] ?? const <Node>[]) {
        out.add(c.id);
        walk(c.id);
      }
    }

    walk(id);
    return out;
  }

  int projectCount(int tabId) {
    var count = 0;
    void walk(int id) {
      for (final c in childrenOf(id)) {
        if (c.type == NodeType.project) count++;
        walk(c.id);
      }
    }

    walk(tabId);
    return count;
  }

  /// FR-04 — structural filter + literal text, instant.
  List<Node> search({
    String query = '',
    int? tabId,
    int? subId,
    int? sectionId,
    NodeType? type,
    NodeStatus? status,
  }) {
    Iterable<Node> pool = nodes;
    if (sectionId != null) {
      pool = pool.where((n) => n.parentId == sectionId);
    } else if (subId != null) {
      final desc = descendantIds(subId).toSet();
      pool = pool.where((n) => desc.contains(n.id) || n.id == subId);
    } else if (tabId != null) {
      final desc = descendantIds(tabId).toSet();
      pool = pool.where((n) => desc.contains(n.id) || n.id == tabId);
    }
    if (type != null) pool = pool.where((n) => n.type == type);
    if (status != null) pool = pool.where((n) => n.status == status);
    final q = query.trim().toLowerCase();
    if (q.isNotEmpty) pool = pool.where((n) => n.name.toLowerCase().contains(q));
    return pool.toList();
  }
}

final treeProvider = StreamProvider<TreeState>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.nodesDao.watchNodes().asyncMap((nodes) async {
    final counts = await db.visitCountsSince(
        DateTime.now().subtract(const Duration(days: 7)));
    return TreeState(nodes, visitCounts: counts);
  });
});

// ── Node actions (FR-03 edit/delete + D-010 undo/trash) ──────────────
class NodeActions {
  final Ref _ref;
  DeleteSnapshot? _lastDelete;
  NodeActions(this._ref);

  AppDatabase get _db => _ref.read(appDatabaseProvider);

  Future<int> createNode({
    required String name,
    required NodeType type,
    NodeTemplate? template,
    int? parentId,
    String icon = 'folder',
  }) async {
    final id = await _db.nodesDao.addNode(
      NodesCompanion.insert(
        name: name,
        type: type,
        template: Value(template),
        parentId: Value(parentId),
        icon: Value(icon),
      ),
    );
    if (type == NodeType.project) {
      _ref.read(analyticsProvider).log('first_project_created');
    }
    return id;
  }

  Future<void> updateNode(int id, NodesCompanion entry) =>
      _db.nodesDao.updateNode(id, entry);

  Future<DeleteSnapshot> deleteNode(int id) async =>
      _lastDelete = await _db.nodesDao.softDeleteSubtree(id);

  Future<void> undoDelete() async {
    final s = _lastDelete;
    if (s == null) return;
    await _db.nodesDao.restoreSubtree(s.nodeIds);
    await _rescheduleFor(s.nodeIds);
    _lastDelete = null;
  }

  /// Restore a single node (with its subtree) from the trash screen.
  Future<void> undoSingle(int id) async {
    final ids = [id, ...await _db.nodesDao.descendantIds(id)];
    await _db.nodesDao.restoreSubtree(ids);
    await _rescheduleFor(ids);
  }

  Future<void> purgeTrash() async =>
      _db.nodesDao.purgeOldTrash(AppConstants.trashRetentionDays);

  Future<void> logOpen(int id) async {
    await _db.logOpen(id);
    await _db.touchOpened(id);
  }

  Future<void> _rescheduleFor(List<int> nodeIds) async {
    final alerts = await _db.elementsDao.allEnabledAlerts();
    await _ref
        .read(notificationsProvider)
        .rescheduleAll(alerts.where((a) => nodeIds.contains(a.nodeId)).toList());
  }
}

final nodeActionsProvider = Provider<NodeActions>((ref) => NodeActions(ref));

// ── Element actions (FR-06 + templates, with scheduling hooks) ───────
class ElementActions {
  final Ref _ref;
  ElementActions(this._ref);

  AppDatabase get _db => _ref.read(appDatabaseProvider);
  NotificationService get _notifier => _ref.read(notificationsProvider);

  // Links
  Future<int> addLink(LinksCompanion e) => _db.elementsDao.addLink(e);
  Future<void> updateLink(int id, LinksCompanion e) =>
      _db.elementsDao.updateLink(id, e);
  Future<void> deleteLink(int id) => _db.elementsDao.softDeleteLink(id);
  Future<void> restoreLink(int id) => _db.elementsDao.restoreLink(id);

  // Notes — enforce 50/node (D-007)
  Future<int> addNote(NotesCompanion e) async {
    final count = await _db.elementsDao.countNotes(e.nodeId.value);
    if (count >= AppConstants.maxNotesPerNode) {
      throw const NotesLimitReached();
    }
    return _db.elementsDao.addNote(e);
  }

  Future<void> updateNote(int id, NotesCompanion e) =>
      _db.elementsDao.updateNote(id, e);
  Future<void> deleteNote(int id) => _db.elementsDao.softDeleteNote(id);
  Future<void> restoreNote(int id) => _db.elementsDao.restoreNote(id);

  // Emails
  Future<int> addEmail(EmailsCompanion e) => _db.elementsDao.addEmail(e);
  Future<void> updateEmail(int id, EmailsCompanion e) =>
      _db.elementsDao.updateEmail(id, e);
  Future<void> deleteEmail(int id) => _db.elementsDao.softDeleteEmail(id);
  Future<void> restoreEmail(int id) => _db.elementsDao.restoreEmail(id);

  // Subscriptions
  Future<int> addSubscription(SubscriptionsCompanion e) =>
      _db.elementsDao.addSubscription(e);
  Future<void> updateSubscription(int id, SubscriptionsCompanion e) =>
      _db.elementsDao.updateSubscription(id, e);
  Future<void> deleteSubscription(int id) =>
      _db.elementsDao.softDeleteSubscription(id);
  Future<void> restoreSubscription(int id) =>
      _db.elementsDao.restoreSubscription(id);

  // Platforms
  Future<int> addPlatform(PlatformsCompanion e) =>
      _db.elementsDao.addPlatform(e);
  Future<void> updatePlatform(int id, PlatformsCompanion e) =>
      _db.elementsDao.updatePlatform(id, e);
  Future<void> deletePlatform(int id) => _db.elementsDao.softDeletePlatform(id);
  Future<void> restorePlatform(int id) => _db.elementsDao.restorePlatform(id);

  // Variables
  Future<int> addVariable(VariablesCompanion e) =>
      _db.elementsDao.addVariable(e);
  Future<void> updateVariable(int id, VariablesCompanion e) =>
      _db.elementsDao.updateVariable(id, e);
  Future<void> deleteVariable(int id) =>
      _db.elementsDao.softDeleteVariable(id);
  Future<void> restoreVariable(int id) =>
      _db.elementsDao.restoreVariable(id);

  // Alerts — schedule system notifications (FR-06)
  Future<int> addAlert(AlertsCompanion e) async {
    final id = await _db.elementsDao.addAlert(e);
    final alert = await _db.elementsDao.getAlert(id);
    if (alert != null) await _notifier.scheduleAlert(alert);
    return id;
  }

  Future<void> updateAlert(int id, AlertsCompanion e) async {
    await _db.elementsDao.updateAlert(id, e);
    final alert = await _db.elementsDao.getAlert(id);
    if (alert != null) await _notifier.scheduleAlert(alert);
  }

  Future<void> deleteAlert(int id) async {
    await _db.elementsDao.softDeleteAlert(id);
    await _notifier.cancelAlert(id);
  }

  Future<void> restoreAlert(int id) async {
    await _db.elementsDao.restoreAlert(id);
    final alert = await _db.elementsDao.getAlert(id);
    if (alert != null) await _notifier.scheduleAlert(alert);
  }
}

class NotesLimitReached implements Exception {
  const NotesLimitReached();
}

final elementActionsProvider =
    Provider<ElementActions>((ref) => ElementActions(ref));
