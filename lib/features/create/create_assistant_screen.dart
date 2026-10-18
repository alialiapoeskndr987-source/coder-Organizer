import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/enums.dart';
import '../../data/db/app_database.dart';
import '../../providers/profile_providers.dart';
import '../../providers/tree_providers.dart';
import '../../shared/widgets/common.dart';
import '../../shared/widgets/icon_registry.dart';

/// FR-03 create assistant — pick type, then cascading parent dropdowns with
/// a "➕ New…" option at every level; projects also get a template (D-007).
class CreateAssistantScreen extends ConsumerStatefulWidget {
  final NodeType? presetType;
  final int? presetParentId;
  const CreateAssistantScreen({super.key, this.presetType, this.presetParentId});

  @override
  ConsumerState<CreateAssistantScreen> createState() =>
      _CreateAssistantScreenState();
}

class _CreateAssistantScreenState extends ConsumerState<CreateAssistantScreen> {
  late NodeType _type = widget.presetType ?? NodeType.mainTab;
  int? _tabId;
  int? _subId;
  int? _sectionId;
  int? _itemParentId; // v2.0 — free-tree parent for NodeType.item
  int? _categoryId; // v2.0 (D-023) — optional catalog entry
  NodeTemplate _template = NodeTemplate.custom;
  String _icon = 'folder';
  final _name = TextEditingController();

  static const int _kNew = -1;

  @override
  void initState() {
    super.initState();
    _icon = switch (_type) {
      NodeType.mainTab => 'layers',
      NodeType.subTab => 'folder',
      NodeType.section => 'doc',
      NodeType.project => 'code',
      NodeType.item => 'extension',
    };
    if (widget.presetParentId != null) {
      // Pre-resolve preset parent to the right level.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final tree = ref.read(treeProvider).value;
        if (tree == null) return;
        final byId = {for (final n in tree.nodes) n.id: n};
        final parent = byId[widget.presetParentId];
        if (parent == null) return;
        setState(() {
          switch (parent.type) {
            case NodeType.mainTab:
              _tabId = parent.id;
            case NodeType.subTab:
              _tabId = parent.parentId;
              _subId = parent.id;
            case NodeType.section:
              _tabId = _rootOf(tree, parent);
              _subId = parent.parentId;
              _sectionId = parent.id;
            case NodeType.project || NodeType.item:
              break;
          }
        });
      });
    }
  }

  int? _rootOf(TreeState tree, Node section) {
    for (final n in tree.nodes) {
      if (n.id == section.parentId) return n.parentId;
    }
    return null;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  List<Node> _childrenOf(Iterable<Node> nodes, int? parentId) {
    final list =
        nodes.where((n) => n.parentId == parentId).toList()
          ..sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
    return list;
  }

  Future<int?> _quickCreate(BuildContext context, NodeType type, int? parentId) async {
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: TextField(
          autofocus: true,
          controller: controller,
          maxLength: 120,
          decoration: InputDecoration(labelText: AppLocalizations.of(ctx)!.name),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(AppLocalizations.of(ctx)!.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(AppLocalizations.of(ctx)!.create)),
        ],
      ),
    );
    if (ok != true) return null;
    final name = controller.text.trim();
    if (name.isEmpty) return null;
    return ref.read(nodeActionsProvider).createNode(
          name: name,
          type: type,
          parentId: parentId,
          icon: type == NodeType.mainTab ? 'layers' : 'folder',
        );
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _name.text.trim();
    if (name.isEmpty) {
      showError(context, l10n.fieldRequired);
      return;
    }
    final actions = ref.read(nodeActionsProvider);
    int? parentId;
    switch (_type) {
      case NodeType.mainTab:
        parentId = null;
      case NodeType.subTab:
        parentId = _tabId;
      case NodeType.section:
        parentId = _subId;
      case NodeType.project:
        parentId = _sectionId;
      case NodeType.item:
        parentId = _itemParentId;
    }
    if (_type != NodeType.mainTab && parentId == null) return;
    try {
      await actions.createNode(
        name: name,
        type: _type,
        parentId: parentId,
        categoryId: _categoryId,
        icon: _icon,
        template: _type == NodeType.project ? _template : null,
      );
    } on ProjectLimitReached {
      if (!mounted) return;
      await PaywallGate.showLimitDialog(context, l10n.projectLimitReached);
      return;
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final tree = ref.watch(treeProvider).value ?? const TreeState([]);
    // v2.0 (D-023) — catalog entries for the current profile.
    final profileId = ref.watch(currentProfileIdProvider);
    final categories =
        ref.watch(categoriesProvider(profileId)).value ?? const <CategoryRow>[];
    final tabs = _childrenOf(tree.nodes, null);
    final subs = _tabId == null ? <Node>[] : _childrenOf(tree.nodes, _tabId);
    final sections =
        _subId == null ? <Node>[] : _childrenOf(tree.nodes, _subId);

    Widget dropdown<T>({
      required String label,
      required T? value,
      required List<Node> items,
      required void Function(int?) onPick,
      required bool allowNew,
    }) =>
        DropdownButtonFormField<int>(
          initialValue: value as int?,
          decoration: InputDecoration(labelText: label),
          items: [
            for (final n in items)
              DropdownMenuItem(
                value: n.id,
                child: Row(children: [
                  Icon(iconFor(n.icon),
                      size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(n.name, overflow: TextOverflow.ellipsis)),
                ]),
              ),
            if (allowNew)
              const DropdownMenuItem(
                value: _kNew,
                child: Text('➕ New…'),
              ),
          ],
          onChanged: (v) async {
            if (v == null) return;
            if (v == _kNew) {
              final newId =
                  await _quickCreate(context, NodeType.mainTab, null);
              if (newId != null) onPick(newId);
            } else {
              onPick(v);
            }
            setState(() {});
          },
        );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createNodeTitle(nodeTypeLabel(l10n, _type)))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in NodeType.values)
                ChoiceChip(
                  label: Text(nodeTypeLabel(l10n, t)),
                  selected: _type == t,
                  onSelected: (_) => setState(() {
                    _type = t;
                    _tabId = _subId = _sectionId = _itemParentId = null;
                    _icon = switch (t) {
                      NodeType.mainTab => 'layers',
                      NodeType.subTab => 'folder',
                      NodeType.section => 'doc',
                      NodeType.project => 'code',
                      NodeType.item => 'extension',
                    };
                  }),
                ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _name,
            maxLength: 120,
            decoration: InputDecoration(labelText: l10n.name),
          ),
          const SizedBox(height: 14),
          // v2.0 (D-027) — free-tree parent picker for item nodes.
          if (_type == NodeType.item)
            DropdownButtonFormField<int>(
              initialValue: _itemParentId,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.parentItem),
              items: [
                for (final n in tree.nodes)
                  DropdownMenuItem(
                    value: n.id,
                    child: Row(children: [
                      Icon(iconFor(n.icon),
                          size: 18, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(n.name,
                              overflow: TextOverflow.ellipsis)),
                    ]),
                  ),
              ],
              onChanged: (v) => setState(() => _itemParentId = v),
            ),
          if (_type == NodeType.project || _type == NodeType.item) ...[
            const SizedBox(height: 14),
            DropdownButtonFormField<int>(
              // v2.0 (D-023) — optional category from the 50-entry catalog.
              initialValue: _categoryId,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.categoryOptional),
              items: [
                DropdownMenuItem<int>(
                    value: null, child: Text(l10n.allCategories)),
                for (final c in categories)
                  DropdownMenuItem(
                    value: c.id,
                    child: Text(categoryDisplayName(l10n, c),
                        overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: (v) => setState(() => _categoryId = v),
            ),
          ],
          // Parent chain (contextual)
          if (_type == NodeType.subTab)
            dropdown(
              label: l10n.parentTab,
              value: _tabId,
              items: tabs,
              allowNew: true,
              onPick: (id) {
                _tabId = id;
                _subId = _sectionId = null;
              },
            ),
          if (_type == NodeType.section) ...[
            dropdown(
              label: l10n.parentTab,
              value: _tabId,
              items: tabs,
              allowNew: true,
              onPick: (id) {
                _tabId = id;
                _subId = _sectionId = null;
              },
            ),
            if (_tabId != null)
              dropdown(
                label: l10n.parentSub,
                value: _subId,
                items: subs,
                allowNew: true,
                onPick: (id) {
                  _subId = id;
                  _sectionId = null;
                },
              ),
            if (_subId != null)
              dropdown(
                label: l10n.parentSection,
                value: _sectionId,
                items: sections,
                allowNew: false,
                onPick: (id) => _sectionId = id,
              ),
          ],
          if (_type == NodeType.project) ...[
            dropdown(
              label: l10n.parentTab,
              value: _tabId,
              items: tabs,
              allowNew: true,
              onPick: (id) {
                _tabId = id;
                _subId = _sectionId = null;
              },
            ),
            if (_tabId != null)
              dropdown(
                label: l10n.parentSub,
                value: _subId,
                items: subs,
                allowNew: true,
                onPick: (id) {
                  _subId = id;
                  _sectionId = null;
                },
              ),
            if (_subId != null)
              dropdown(
                label: l10n.parentSection,
                value: _sectionId,
                items: sections,
                allowNew: true,
                onPick: (id) => _sectionId = id,
              ),
            const SizedBox(height: 14),
            Text(l10n.template,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final t in NodeTemplate.values)
                  ChoiceChip(
                    label: Text(templateLabel(l10n, t)),
                    selected: _template == t,
                    onSelected: (_) => setState(() => _template = t),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          ListTile(
            leading:
                Icon(iconFor(_icon), color: theme.colorScheme.primary),
            title: Text(l10n.changeIcon),
            onTap: () async {
              final picked = await pickIconDialog(context, _icon);
              if (picked != null) setState(() => _icon = picked);
            },
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.check),
            label: Text(l10n.create),
          ),
          if (_type == NodeType.project &&
              _template == NodeTemplate.client) ...[
            const SizedBox(height: 10),
            Text(
              '${l10n.registeredEmails} · ${l10n.subscriptions} · ${l10n.platforms} · ${l10n.links} · ${l10n.variables} · ${l10n.alertsWithCount}',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}
