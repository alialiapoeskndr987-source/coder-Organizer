import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/enums.dart';
import '../../providers/tree_providers.dart';
import '../../shared/widgets/common.dart';
import '../../shared/widgets/icon_registry.dart';
import '../tree/tree_browser_screen.dart';

/// v2.0 — paths overview (owner spec): 3 tabs (main / sub / section), each
/// level reachable to the root, with EXPANDABLE rows carrying recursive
/// project counters. The level chain is optional in v2.0 (D-022): rows
/// simply list whatever exists at that level in the current profile.
class PathsScreen extends StatelessWidget {
  const PathsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.pathsTitle),
          bottom: TabBar(tabs: [
            Tab(text: l10n.mainTab),
            Tab(text: l10n.subTab),
            Tab(text: l10n.section),
          ]),
        ),
        body: const TabBarView(
          children: [_PathLevel(NodeType.mainTab), _PathLevel(NodeType.subTab), _PathLevel(NodeType.section)],
        ),
      ),
    );
  }
}

class _PathLevel extends ConsumerWidget {
  final NodeType levelType;
  const _PathLevel(this.levelType);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final treeAsync = ref.watch(treeProvider);

    return treeAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) =>
          EmptyState(icon: Icons.error_outline, message: l10n.unexpectedError),
      data: (tree) {
        final rows =
            tree.nodes.where((n) => n.type == levelType).toList()
              ..sort((a, b) => a.sortIndex.compareTo(b.sortIndex));
        if (rows.isEmpty) {
          return EmptyState(
              icon: Icons.account_tree_outlined, message: l10n.emptyState);
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: rows.length,
          separatorBuilder: (_, __) => const SizedBox(height: 6),
          itemBuilder: (context, i) {
            final node = rows[i];
            final count = tree.projectCount(node.id);
            final children = tree.childrenOf(node.id);
            return Card(
              child: ExpansionTile(
                leading: Icon(iconFor(node.icon),
                    color: theme.colorScheme.primary),
                title: Text(node.name,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.projectsCount(count),
                    style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                children: [
                  if (children.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(l10n.emptyState,
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant)),
                    )
                  else
                    for (final c in children)
                      ListTile(
                        dense: true,
                        leading: Icon(iconFor(c.icon), size: 20,
                            color: theme.colorScheme.secondary),
                        title: Text(c.name,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: Text(l10n.projectsCount(tree.projectCount(c.id)),
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant)),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => TreeBrowserScreen(nodeId: c.id)),
                        ),
                      ),
                  const SizedBox(height: 6),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
