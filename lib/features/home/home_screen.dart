import 'package:flutter/material.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/enums.dart';
import '../../data/db/app_database.dart';
import '../../providers/core_providers.dart';
import '../../providers/settings_providers.dart';
import '../../providers/tree_providers.dart';
import '../../shared/widgets/common.dart';
import '../../shared/widgets/icon_registry.dart';
import '../create/create_assistant_screen.dart';
import '../paywall/paywall_screen.dart';
import '../paths/paths_screen.dart';
import '../profiles/profile_switcher.dart';
import '../search/search_screen.dart';
import '../trash/trash_screen.dart';
import '../tree/tree_browser_screen.dart';

/// FR-05 — custom title, tabs grid (icon+name+project count),
/// "most visited (7 days)", "recently opened", floating create button.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _openCreate(BuildContext context, WidgetRef ref) async {
    if (!await PaywallGate.ensure(context, ref)) return;
    if (!context.mounted) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => const CreateAssistantScreen(),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final treeAsync = ref.watch(treeProvider);
    final mainTitle = ref.watch(mainTitleProvider);
    final trial = ref.watch(trialProvider).value;
    final prefs = ref.watch(homePrefsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          mainTitle.isEmpty ? l10n.defaultWorkspaceTitle : mainTitle,
          style: theme.appBarTheme.titleTextStyle
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        actions: [
          const ProfileSwitcher(),
          IconButton(
            tooltip: l10n.pathsTitle,
            icon: const Icon(Icons.account_tree_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PathsScreen()),
            ),
          ),
          IconButton(
            tooltip: l10n.search,
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),
          IconButton(
            tooltip: l10n.trash,
            icon: const Icon(Icons.delete_outline),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TrashScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreate(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.createNew),
      ),
      body: treeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            EmptyState(icon: Icons.error_outline, message: l10n.unexpectedError),
        data: (tree) {
          final roots = tree.rootTabs;
          final byId = {for (final n in tree.nodes) n.id: n};

          // v1.23 — workspace overview stats (toggleable in settings).
          final subTabsCount =
              tree.nodes.where((n) => n.type == NodeType.subTab).length;
          final sectionsCount =
              tree.nodes.where((n) => n.type == NodeType.section).length;
          final projectsCount =
              tree.nodes.where((n) => n.type == NodeType.project).length;


          final mostVisited = (tree.visitCounts.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value)))
              .where((e) => byId.containsKey(e.key))
              .take(5)
              .map((e) => byId[e.key]!)
              .toList();
          final recent = (tree.nodes.where((n) => n.lastOpenedAt != null).toList()
                ..sort((a, b) => b.lastOpenedAt!.compareTo(a.lastOpenedAt!)))
              .take(8)
              .toList();

          return ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              if (trial != null && !trial.purchased) _TrialBanner(daysLeft: trial.daysLeft),
              if (prefs.showStats) ...[
                SectionHeader(title: l10n.overview),
                SizedBox(
                  height: 92,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      _StatCard(
                          icon: Icons.tab_outlined,
                          label: l10n.statTabs,
                          value: roots.length),
                      _StatCard(
                          icon: Icons.account_tree_outlined,
                          label: l10n.statSubTabs,
                          value: subTabsCount),
                      _StatCard(
                          icon: Icons.folder_special_outlined,
                          label: l10n.statSections,
                          value: sectionsCount),
                      _StatCard(
                          icon: Icons.work_outline,
                          label: l10n.statProjects,
                          value: projectsCount),
                    ],
                  ),
                ),
              ],
              if (mostVisited.isNotEmpty) ...[
                SectionHeader(title: l10n.mostVisited),
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: mostVisited.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final n = mostVisited[i];
                      return ActionChip(
                        avatar: Icon(iconFor(n.icon),
                            size: 18, color: theme.colorScheme.primary),
                        label: Text(n.name, overflow: TextOverflow.ellipsis),
                        onPressed: () => _openNode(context, n.id),
                      );
                    },
                  ),
                ),
              ],
              if (recent.isNotEmpty) ...[
                SectionHeader(title: l10n.lastOpened),
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: recent.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final n = recent[i];
                      return ActionChip(
                        avatar: Icon(iconFor(n.icon),
                            size: 18, color: theme.colorScheme.secondary),
                        label: Text(n.name, overflow: TextOverflow.ellipsis),
                        onPressed: () => _openNode(context, n.id),
                      );
                    },
                  ),
                ),
              ],
              SectionHeader(
                title: l10n.home,
                trailing: Text(
                  l10n.childrenCount(roots.length),
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
              if (roots.isEmpty)
                EmptyState(icon: Icons.space_dashboard_outlined, message: l10n.emptyState)
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    // v1.23 — grid density follows the compact preference.
                    maxCrossAxisExtent: prefs.compactGrid ? 150 : 220,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: prefs.compactGrid ? 1.3 : 1.55,
                  ),
                  itemCount: roots.length,
                  itemBuilder: (context, i) {
                    final n = roots[i];
                    return _TabCard(
                      node: n,
                      projectCount: tree.projectCount(n.id),
                      onTap: () => _openNode(context, n.id),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  void _openNode(BuildContext context, int id) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => TreeBrowserScreen(nodeId: id),
    ));
  }
}

class _TrialBanner extends StatelessWidget {
  final int daysLeft;
  const _TrialBanner({required this.daysLeft});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final text = daysLeft <= 1 ? l10n.trialLastDay : l10n.trialBanner(daysLeft);
    final isLast = daysLeft <= 1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Card(
        color: theme.colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Icon(Icons.hourglass_top_rounded,
                  size: 20, color: theme.colorScheme.onPrimaryContainer),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                ),
              ),
              if (isLast)
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PaywallScreen()),
                  ),
                  child: Text(l10n.upgrade),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabCard extends StatelessWidget {
  final Node node;
  final int projectCount;
  final VoidCallback onTap;
  const _TabCard({
    required this.node,
    required this.projectCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(iconFor(node.icon), size: 28, color: theme.colorScheme.primary),
              const Spacer(),
              Text(
                node.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                AppLocalizations.of(context)!.projectsCount(projectCount),
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// v1.23 — compact overview stat card shown on the home screen.
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Container(
        width: 128,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(children: [
              Icon(icon, size: 18, color: theme.colorScheme.primary),
              const Spacer(),
              Text(
                '$value',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
            ]),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
