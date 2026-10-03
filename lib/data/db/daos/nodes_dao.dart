part of '../app_database.dart';

@DriftAccessor(tables: [
  Nodes,
  Links,
  Notes,
  Emails,
  Subscriptions,
  Platforms,
  Variables,
  Alerts,
  OpenLogs,
])
class NodesDao extends DatabaseAccessor<AppDatabase> with _$NodesDaoMixin {
  NodesDao(super.db);

  Stream<List<Node>> watchNodes({bool includeDeleted = false}) {
    final q = select(nodes);
    if (!includeDeleted) q.where((n) => n.deletedAt.isNull());
    q.orderBy([
      (n) => OrderingTerm.asc(n.sortIndex),
      (n) => OrderingTerm.asc(n.id),
    ]);
    return q.watch();
  }

  Future<Node?> getNode(int id) =>
      (select(nodes)..where((n) => n.id.equals(id))).getSingleOrNull();

  Future<int> addNode(NodesCompanion entry) => into(nodes).insert(entry);

  Future<void> updateNode(int id, NodesCompanion entry) =>
      (update(nodes)..where((n) => n.id.equals(id))).write(
        entry.copyWith(updatedAt: Value(DateTime.now())),
      );

  /// All descendant ids (in-memory walk — volumes are local-app scale).
  Future<List<int>> descendantIds(int id, {bool includeDeleted = true}) async {
    final all = await select(nodes).get();
    final byParent = <int?, List<Node>>{};
    for (final n in all) {
      (byParent[n.parentId] ??= []).add(n);
    }
    final out = <int>[];
    void walk(int parent) {
      for (final c in byParent[parent] ?? const <Node>[]) {
        if (!includeDeleted && c.deletedAt != null) continue;
        out.add(c.id);
        walk(c.id);
      }
    }

    walk(id);
    return out;
  }

  /// Soft-delete a node + descendants + all elements (trash, D-010).
  /// Returns a snapshot used for instant undo.
  Future<DeleteSnapshot> softDeleteSubtree(int id) async {
    final ids = [id, ...await descendantIds(id)];
    final now = DateTime.now();
    await (update(nodes)..where((n) => n.id.isIn(ids)))
        .write(NodesCompanion(deletedAt: Value(now)));
    await (update(links)..where((l) => l.nodeId.isIn(ids)))
        .write(LinksCompanion(deletedAt: Value(now)));
    await (update(notes)..where((n) => n.nodeId.isIn(ids)))
        .write(NotesCompanion(deletedAt: Value(now)));
    await (update(emails)..where((e) => e.nodeId.isIn(ids)))
        .write(EmailsCompanion(deletedAt: Value(now)));
    await (update(subscriptions)..where((s) => s.nodeId.isIn(ids)))
        .write(SubscriptionsCompanion(deletedAt: Value(now)));
    await (update(platforms)..where((p) => p.nodeId.isIn(ids)))
        .write(PlatformsCompanion(deletedAt: Value(now)));
    await (update(variables)..where((v) => v.nodeId.isIn(ids)))
        .write(VariablesCompanion(deletedAt: Value(now)));
    await (update(alerts)..where((a) => a.nodeId.isIn(ids)))
        .write(AlertsCompanion(deletedAt: Value(now)));
    return DeleteSnapshot(nodeIds: ids, deletedAt: now);
  }

  /// Undo path (D-010): clear deletedAt on the subtree and its elements.
  Future<void> restoreSubtree(List<int> ids) async {
    await (update(nodes)..where((n) => n.id.isIn(ids)))
        .write(NodesCompanion(deletedAt: const Value<DateTime?>(null)));
    await (update(links)..where((l) => l.nodeId.isIn(ids)))
        .write(LinksCompanion(deletedAt: const Value<DateTime?>(null)));
    await (update(notes)..where((n) => n.nodeId.isIn(ids)))
        .write(NotesCompanion(deletedAt: const Value<DateTime?>(null)));
    await (update(emails)..where((e) => e.nodeId.isIn(ids)))
        .write(EmailsCompanion(deletedAt: const Value<DateTime?>(null)));
    await (update(subscriptions)..where((s) => s.nodeId.isIn(ids)))
        .write(SubscriptionsCompanion(deletedAt: const Value<DateTime?>(null)));
    await (update(platforms)..where((p) => p.nodeId.isIn(ids)))
        .write(PlatformsCompanion(deletedAt: const Value<DateTime?>(null)));
    await (update(variables)..where((v) => v.nodeId.isIn(ids)))
        .write(VariablesCompanion(deletedAt: const Value<DateTime?>(null)));
    await (update(alerts)..where((a) => a.nodeId.isIn(ids)))
        .write(AlertsCompanion(deletedAt: const Value<DateTime?>(null)));
  }

  Future<void> permanentlyDeleteNodes(List<int> ids) async {
    await (delete(links)..where((l) => l.nodeId.isIn(ids))).go();
    await (delete(notes)..where((n) => n.nodeId.isIn(ids))).go();
    await (delete(emails)..where((e) => e.nodeId.isIn(ids))).go();
    await (delete(subscriptions)..where((s) => s.nodeId.isIn(ids))).go();
    await (delete(platforms)..where((p) => p.nodeId.isIn(ids))).go();
    await (delete(variables)..where((v) => v.nodeId.isIn(ids))).go();
    await (delete(alerts)..where((a) => a.nodeId.isIn(ids))).go();
    await (delete(openLogs)..where((l) => l.nodeId.isIn(ids))).go();
    await (delete(nodes)..where((n) => n.id.isIn(ids))).go();
  }

  /// Purge trash past the retention window; returns purged node ids.
  Future<List<int>> purgeOldTrash(int retentionDays) async {
    final cutoff = DateTime.now().subtract(Duration(days: retentionDays));
    final old = await (select(nodes)
          ..where((n) => n.deletedAt.isSmallerOrEqualValue(cutoff)))
        .get();
    final ids = old.map((n) => n.id).toList();
    if (ids.isNotEmpty) await permanentlyDeleteNodes(ids);
    return ids;
  }

  Future<List<Node>> trashedNodes() =>
      (select(nodes)..where((n) => n.deletedAt.isNotNull())).get();
}
