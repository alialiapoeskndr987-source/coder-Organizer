import 'package:flutter/material.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/enums.dart';
import '../../data/db/app_database.dart';
import '../../providers/tree_providers.dart';
import '../../shared/widgets/common.dart';
import '../../shared/widgets/icon_registry.dart';
import '../create/create_assistant_screen.dart';
import '../node/node_details_screen.dart';
import '../tree/tree_browser_screen.dart';

/// FR-04 — structural dropdown filters (populated from real data, with a
/// "➕ New…" option on each) + literal text search, instant results.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String _query = '';
  int? _tabId;
  int? _subId;
  int? _sectionId;
  NodeType? _type;
  NodeStatus? _status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final tree = ref.watch(treeProvider).value ?? const TreeState([]);

    final tabs = tree.nodes.where((n) => n.type == NodeType.mainTab).toList()
      ..sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
    final subs = tree.nodes.where((n) => n.parentId == _tabId).toList();
    final sections = tree.nodes.where((n) => n.parentId == _subId).toList();

    final results = tree.search(
      query: _query,
      tabId: _tabId,
      subId: _subId,
      sectionId: _sectionId,
      type: _type,
      status: _status,
    );

    Widget parentDropdown({
      required String label,
      required int? value,
      required List<Node> items,
      required ValueChanged<int?> onPick,
      bool allowNew = false,
    }) =>
        DropdownButtonFormField<int>(
          initialValue: value,
          isExpanded: true,
          decoration: InputDecoration(labelText: label),
          items: [
            DropdownMenuItem<int>(
                value: null, child: Text(l10n.allOption)),
            for (final n in items)
              DropdownMenuItem(
                value: n.id,
                child: Row(children: [
                  Icon(iconFor(n.icon),
                      size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Text(n.name, overflow: TextOverflow.ellipsis)),
                ]),
              ),
            if (allowNew)
              const DropdownMenuItem(value: -1, child: Text('➕ New…')),
          ],
          onChanged: onPick,
        );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.search)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                parentDropdown(
                  label: l10n.filterTab,
                  value: _tabId,
                  items: tabs,
                  allowNew: true,
                  onPick: (v) => setState(() {
                    if (v == -1) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const CreateAssistantScreen(
                            presetType: NodeType.mainTab),
                      ));
                      return;
                    }
                    _tabId = v;
                    _subId = _sectionId = null;
                  }),
                ),
                const SizedBox(height: 10),
                parentDropdown(
                  label: l10n.filterSub,
                  value: _subId,
                  items: subs,
                  allowNew: _tabId != null,
                  onPick: (v) => setState(() {
                    if (v == -1) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => CreateAssistantScreen(
                            presetType: NodeType.subTab,
                            presetParentId: _tabId),
                      ));
                      return;
                    }
                    _subId = v;
                    _sectionId = null;
                  }),
                ),
                const SizedBox(height: 10),
                parentDropdown(
                  label: l10n.filterSection,
                  value: _sectionId,
                  items: sections,
                  allowNew: _subId != null,
                  onPick: (v) => setState(() {
                    if (v == -1) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => CreateAssistantScreen(
                            presetType: NodeType.section,
                            presetParentId: _subId),
                      ));
                      return;
                    }
                    _sectionId = v;
                  }),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                    child: DropdownButtonFormField<NodeType>(
                      initialValue: _type,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: l10n.nodeType),
                      items: [
                        DropdownMenuItem<NodeType>(
                            value: null, child: Text(l10n.allOption)),
                        for (final t in NodeType.values)
                          DropdownMenuItem(
                              value: t, child: Text(nodeTypeLabel(l10n, t))),
                      ],
                      onChanged: (v) => setState(() => _type = v),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<NodeStatus>(
                      initialValue: _status,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: l10n.filterStatus),
                      items: [
                        DropdownMenuItem<NodeStatus>(
                            value: null, child: Text(l10n.allOption)),
                        DropdownMenuItem(
                            value: NodeStatus.active,
                            child: Text(l10n.statusActive)),
                        DropdownMenuItem(
                            value: NodeStatus.archived,
                            child: Text(l10n.statusArchived)),
                      ],
                      onChanged: (v) => setState(() => _status = v),
                    ),
                  ),
                ]),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(l10n.resultsCount(results.length),
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? EmptyState(icon: Icons.search_off, message: l10n.noResults)
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (context, i) {
                      final n = results[i];
                      return Card(
                        child: ListTile(
                          leading: Icon(iconFor(n.icon),
                              color: theme.colorScheme.primary),
                          title: Text(n.name),
                          subtitle: Text(nodeTypeLabel(l10n, n.type)),
                          trailing: const Icon(Icons.chevron_right, size: 20),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => n.type == NodeType.project
                                  ? NodeDetailsScreen(nodeId: n.id)
                                  : TreeBrowserScreen(nodeId: n.id),
                            ));
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
