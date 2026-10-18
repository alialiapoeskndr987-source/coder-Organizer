import 'package:flutter/material.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../providers/core_providers.dart';
import '../../providers/profile_providers.dart';
import '../../providers/security_providers.dart';
import '../../providers/tree_providers.dart';
import '../../shared/widgets/common.dart';
import '../../shared/widgets/icon_registry.dart';
import '../tree/tree_browser_screen.dart';

/// Trash (D-010, D-024): 30-day retention, restore, permanent delete,
/// purge all — now with two tabs: content nodes AND deleted profiles.
class TrashScreen extends ConsumerStatefulWidget {
  const TrashScreen({super.key});

  @override
  ConsumerState<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends ConsumerState<TrashScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);
  late Future<List<Node>> _future;
  late Future<List<Profile>> _profilesFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  void _reload() {
    _future = ref.read(appDatabaseProvider).nodesDao.trashedNodes();
    _profilesFuture = ref.read(appDatabaseProvider).trashedProfiles();
  }

  Future<void> _restore(Node n) async {
    await ref.read(nodeActionsProvider).undoSingle(n.id);
    if (!mounted) return;
    setState(_reload);
    showError(context, AppLocalizations.of(context)!.restored);
  }

  Future<bool> _sensitiveGate() => requestSensitiveAuth(context, ref);

  Future<void> _deleteForever(Node n) async {
    final l10n = AppLocalizations.of(context)!;
    if (!await _sensitiveGate()) return;
    final ok = await confirmDialog(
      context,
      title: l10n.deleteForever,
      message: l10n.purgeConfirm,
      destructive: true,
    );
    if (!ok) return;
    await ref
        .read(appDatabaseProvider)
        .nodesDao
        .permanentlyDeleteNodes([n.id]);
    if (!mounted) return;
    setState(_reload);
  }

  Future<void> _purgeAll() async {
    final l10n = AppLocalizations.of(context)!;
    if (!await _sensitiveGate()) return;
    final ok = await confirmDialog(
      context,
      title: l10n.purgeNow,
      message: l10n.purgeConfirm,
      destructive: true,
    );
    if (!ok) return;
    await ref.read(appDatabaseProvider).nodesDao.purgeOldTrash(0);
    if (!mounted) return;
    setState(_reload);
  }

  Future<void> _restoreProfile(Profile p) async {
    await ref.read(profileActionsProvider).restore(p.id);
    if (!mounted) return;
    setState(_reload);
    showError(context, AppLocalizations.of(context)!.profileRestored);
  }

  Future<void> _deleteProfileForever(Profile p) async {
    final l10n = AppLocalizations.of(context)!;
    if (!await _sensitiveGate()) return;
    final ok = await confirmDialog(
      context,
      title: l10n.deleteForever,
      message: l10n.purgeConfirm,
      destructive: true,
    );
    if (!ok) return;
    await ref.read(profileActionsProvider).deleteForever(p.id);
    if (!mounted) return;
    setState(_reload);
  }

  Future<void> _emptyProfilesTrash() async {
    final l10n = AppLocalizations.of(context)!;
    if (!await _sensitiveGate()) return;
    final ok = await confirmDialog(
      context,
      title: l10n.purgeProfiles,
      message: l10n.purgeConfirm,
      destructive: true,
    );
    if (!ok) return;
    await ref.read(profileActionsProvider).emptyTrash();
    if (!mounted) return;
    setState(_reload);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.trash),
        bottom: TabBar(controller: _tabs, tabs: [
          Tab(text: l10n.trashItemsTab),
          Tab(text: l10n.profilesTrash),
        ]),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildNodesTab(theme, l10n),
          _buildProfilesTab(theme, l10n),
        ],
      ),
    );
  }

  Widget _buildNodesTab(ThemeData theme, AppLocalizations l10n) {
    return FutureBuilder<List<Node>>(
      future: _future,
      builder: (context, snap) {
        final items = snap.data ?? const [];
        if (items.isEmpty) {
          return EmptyState(icon: Icons.delete_outline, message: l10n.trashEmpty);
        }
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Row(children: [
                Expanded(
                  child: Text(l10n.trashAutoPurge,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
                ),
                TextButton(onPressed: _purgeAll, child: Text(l10n.purgeNow)),
              ]),
            ),
            for (final n in items)
              Card(
                child: ListTile(
                  leading: Icon(iconFor(n.icon),
                      color: theme.colorScheme.onSurfaceVariant),
                  title: Text(n.name),
                  subtitle: Text(n.deletedAt
                          ?.toString()
                          .substring(0, 10) ??
                      ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: l10n.restoreNode,
                        icon: const Icon(Icons.restore),
                        onPressed: () => _restore(n),
                      ),
                      IconButton(
                        tooltip: l10n.deleteForever,
                        icon: Icon(Icons.delete_forever,
                            color: theme.colorScheme.error),
                        onPressed: () => _deleteForever(n),
                      ),
                    ],
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => TreeBrowserScreen(nodeId: n.id)),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildProfilesTab(ThemeData theme, AppLocalizations l10n) {
    return FutureBuilder<List<Profile>>(
      future: _profilesFuture,
      builder: (context, snap) {
        final items = snap.data ?? const [];
        if (items.isEmpty) {
          return EmptyState(icon: Icons.person_off_outlined, message: l10n.trashEmpty);
        }
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Row(children: [
                Expanded(
                  child: Text(l10n.trashAutoPurge,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
                ),
                TextButton(
                    onPressed: _emptyProfilesTrash,
                    child: Text(l10n.purgeProfiles)),
              ]),
            ),
            for (final p in items)
              Card(
                child: ListTile(
                  leading: Icon(Icons.person_off_outlined,
                      color: theme.colorScheme.onSurfaceVariant),
                  title: Text(p.name),
                  subtitle:
                      Text(p.deletedAt?.toString().substring(0, 10) ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: l10n.restoreNode,
                        icon: const Icon(Icons.restore),
                        onPressed: () => _restoreProfile(p),
                      ),
                      IconButton(
                        tooltip: l10n.deleteForever,
                        icon: Icon(Icons.delete_forever,
                            color: theme.colorScheme.error),
                        onPressed: () => _deleteProfileForever(p),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
