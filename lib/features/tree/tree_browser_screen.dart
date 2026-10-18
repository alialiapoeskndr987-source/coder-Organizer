import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart' show Value;
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/enums.dart';
import '../../data/db/app_database.dart';
import '../../providers/settings_providers.dart';
import '../../providers/tree_providers.dart';
import '../../providers/undo_providers.dart';
import '../../shared/widgets/common.dart';
import '../../shared/widgets/icon_registry.dart';
import '../create/create_assistant_screen.dart';
import '../node/node_details_screen.dart';

/// Breadcrumb tree browser (FR-03): Tab → Sub → Section → Project.
class TreeBrowserScreen extends ConsumerStatefulWidget {
  final int nodeId;
  const TreeBrowserScreen({super.key, required this.nodeId});

  @override
  ConsumerState<TreeBrowserScreen> createState() => _TreeBrowserScreenState();
}

class _TreeBrowserScreenState extends ConsumerState<TreeBrowserScreen> {
  /// v1.23 — status filter for children (null = show all).
  NodeStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(nodeActionsProvider).logOpen(widget.nodeId));
  }

  NodeType? get _expectedChildType {
    final node = _node;
    if (node == null) return null;
    // v2.0 (D-022/D-027) — the 3-level chain is optional and projects/items
    // grow a FREE tree: any project or item accepts item children.
    return switch (node.type) {
      NodeType.mainTab => NodeType.subTab,
      NodeType.subTab => NodeType.section,
      NodeType.section => NodeType.project,
      NodeType.project => NodeType.item,
      NodeType.item => NodeType.item,
    };
  }

  Node? get _node {
    final tree = ref.read(treeProvider).value;
    if (tree == null) return null;
    final byId = {for (final n in tree.nodes) n.id: n};
    return byId[widget.nodeId];
  }

  Future<void> _delete(Node node) async {
    final l10n = AppLocalizations.of(context)!;
    final tree = ref.read(treeProvider).value!;
    final count = tree.descendantIds(node.id).length;
    final ok = await confirmDialog(
      context,
      title: l10n.deleteNodeTitle(node.name),
      message: count > 0 ? l10n.deleteCascadeWarn(count) : null,
      destructive: true,
    );
    if (!ok || !mounted) return;
    await ref.read(nodeActionsProvider).deleteNode(node.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(l10n.movedToTrash),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () =>
              ref.read(nodeActionsProvider).undoDelete(),
        ),
      ));
    Navigator.of(context).pop();
  }

  Future<void> _rename(Node node) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: node.name);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.renameNode),
        content: TextField(
          autofocus: true,
          controller: controller,
          maxLength: 120,
          decoration: InputDecoration(labelText: l10n.name),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.save)),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final name = controller.text.trim();
    if (name.isEmpty) return;
    await ref
        .read(nodeActionsProvider)
        .updateNode(node.id, NodesCompanion(name: Value(name)));
  }

  Future<void> _changeIcon(Node node) async {
    final icon = await pickIconDialog(context, node.icon);
    if (icon == null) return;
    await ref
        .read(nodeActionsProvider)
        .updateNode(node.id, NodesCompanion(icon: Value(icon)));
  }

  Future<void> _toggleStatus(Node node) async {
    final next = node.status == NodeStatus.active
        ? NodeStatus.archived
        : NodeStatus.active;
    await ref
        .read(nodeActionsProvider)
        .updateNode(node.id, NodesCompanion(status: Value(next)));
  }

  Future<void> _addChild(Node parent, NodeType type) async {
    if (!await PaywallGate.ensure(context, ref)) return;
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CreateAssistantScreen(
        presetType: type,
        presetParentId: parent.id,
      ),
    ));
  }

  void _openChild(Node child) {
    if (child.type == NodeType.project) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => NodeDetailsScreen(nodeId: child.id),
      ));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => TreeBrowserScreen(nodeId: child.id),
      ));
    }
  }

  /// v2.0 (D-025) — undo the most recent structural change.
  Future<void> _undo() async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await ref.read(undoProvider.notifier).undo();
    if (!mounted) return;
    showError(context, ok ? l10n.undoDone : l10n.nothingToUndo);
  }

  /// v1.23 — sort menu (persisted, shared with search & settings).
  Widget _sortMenu(AppLocalizations l10n, NodeSort sort) =>
      PopupMenuButton<NodeSort>(
        icon: const Icon(Icons.sort),
        tooltip: l10n.sortBy,
        onSelected: (s) =>
            ref.read(nodeSortProvider.notifier).setSort(s),
        itemBuilder: (ctx) => [
          CheckedPopupMenuItem(
              value: NodeSort.manual,
              checked: sort == NodeSort.manual,
              child: Text(l10n.sortManual)),
          CheckedPopupMenuItem(
              value: NodeSort.nameAZ,
              checked: sort == NodeSort.nameAZ,
              child: Text(l10n.sortNameAZ)),
          CheckedPopupMenuItem(
              value: NodeSort.newest,
              checked: sort == NodeSort.newest,
              child: Text(l10n.sortNewest)),
          CheckedPopupMenuItem(
              value: NodeSort.oldest,
              checked: sort == NodeSort.oldest,
              child: Text(l10n.sortOldest)),
        ],
      );

  /// v1.23 — status filter chips (all / active / archived).
  Widget _statusChips(AppLocalizations l10n) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
        child: Row(children: [
          FilterChip(
            selected: _statusFilter == null,
            showCheckmark: false,
            label: Text(l10n.allOption),
            onSelected: (_) => setState(() => _statusFilter = null),
          ),
          const SizedBox(width: 8),
          FilterChip(
            selected: _statusFilter == NodeStatus.active,
            showCheckmark: false,
            label: Text(l10n.statusActive),
            onSelected: (_) =>
                setState(() => _statusFilter = NodeStatus.active),
          ),
          const SizedBox(width: 8),
          FilterChip(
            selected: _statusFilter == NodeStatus.archived,
            showCheckmark: false,
            label: Text(l10n.statusArchived),
            onSelected: (_) =>
                setState(() => _statusFilter = NodeStatus.archived),
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final treeAsync = ref.watch(treeProvider);

    return treeAsync.when(
      loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: EmptyState(icon: Icons.error_outline, message: l10n.unexpectedError),
      ),
      data: (tree) {
        final node = tree.nodes.where((n) => n.id == widget.nodeId).firstOrNull;
        if (node == null) {
          return Scaffold(
            appBar: AppBar(),
            body: EmptyState(icon: Icons.search_off, message: l10n.noResults),
          );
        }
        final sort = ref.watch(nodeSortProvider);
        var children = tree.childrenOf(node.id);
        if (_statusFilter != null) {
          children =
              children.where((c) => c.status == _statusFilter).toList();
        }
        children = sortNodes(children, sort);
        final breadcrumb = tree.breadcrumbOf(node.id);
        final childType = _expectedChildType;

        return Scaffold(
          appBar: AppBar(
            title: Text(node.name),
            actions: [
              // v2.0 (D-025) — global structural undo (last ~10 ops).
              IconButton(
                tooltip: l10n.undoLast,
                icon: const Icon(Icons.undo),
                onPressed:
                    ref.watch(undoProvider) > 0 ? _undo : null,
              ),
              _sortMenu(l10n, sort),
              PopupMenuButton<String>(
                onSelected: (v) => switch (v) {
                  'rename' => _rename(node),
                  'icon' => _changeIcon(node),
                  'status' => _toggleStatus(node),
                  'delete' => _delete(node),
                  _ => {},
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(value: 'rename', child: Text(l10n.renameNode)),
                  PopupMenuItem(value: 'icon', child: Text(l10n.changeIcon)),
                  PopupMenuItem(
                      value: 'status',
                      child: Text(node.status == NodeStatus.active
                          ? l10n.statusArchived
                          : l10n.statusActive)),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(l10n.delete,
                        style: TextStyle(color: theme.colorScheme.error)),
                  ),
                ],
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(44),
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: breadcrumb.length,
                  separatorBuilder: (_, __) =>
                      const Icon(Icons.chevron_right, size: 18),
                  itemBuilder: (context, i) {
                    final crumb = breadcrumb[i];
                    return TextButton.icon(
                      onPressed: i == breadcrumb.length - 1
                          ? null
                          : () => Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      TreeBrowserScreen(nodeId: crumb.id),
                                ),
                              ),
                      icon: Icon(iconFor(crumb.icon),
                          size: 16, color: theme.colorScheme.primary),
                      label: Text(crumb.name, overflow: TextOverflow.ellipsis),
                    );
                  },
                ),
              ),
            ),
          ),
          floatingActionButton: childType == null
              ? null
              : FloatingActionButton.extended(
                  onPressed: () => _addChild(node, childType),
                  icon: const Icon(Icons.add),
                  label: Text(nodeTypeLabel(l10n, childType)),
                ),
          body: Column(
            children: [
              _statusChips(l10n),
              Expanded(
                child: children.isEmpty
                    ? EmptyState(
                        icon: Icons.category_outlined,
                        message: l10n.emptyState)
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: children.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 6),
                        itemBuilder: (context, i) {
                          final c = children[i];
                          return Card(
                            child: ListTile(
                              leading: Icon(iconFor(c.icon),
                                  color: theme.colorScheme.primary),
                              title: Text(c.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              subtitle: c.status == NodeStatus.archived
                                  ? Text(l10n.statusArchived)
                                  : Text(nodeTypeLabel(l10n, c.type)),
                              trailing:
                                  const Icon(Icons.chevron_right, size: 20),
                              onTap: () => _openChild(c),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
