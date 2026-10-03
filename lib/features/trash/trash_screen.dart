import 'package:flutter/material.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../providers/core_providers.dart';
import '../../providers/tree_providers.dart';
import '../../shared/widgets/common.dart';
import '../../shared/widgets/icon_registry.dart';
import '../tree/tree_browser_screen.dart';

/// Trash (D-010): 30-day retention, restore, permanent delete, purge all.
class TrashScreen extends ConsumerStatefulWidget {
  const TrashScreen({super.key});

  @override
  ConsumerState<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends ConsumerState<TrashScreen> {
  late Future<List<Node>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _future =
        ref.read(appDatabaseProvider).nodesDao.trashedNodes();
  }

  Future<void> _restore(Node n) async {
    await ref.read(nodeActionsProvider).undoSingle(n.id);
    if (!mounted) return;
    setState(_reload);
    showError(context, AppLocalizations.of(context)!.restored);
  }

  Future<void> _deleteForever(Node n) async {
    final l10n = AppLocalizations.of(context)!;
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
    final ok = await confirmDialog(
      context,
      title: l10n.purgeNow,
      message: l10n.purgeConfirm,
      destructive: true,
    );
    if (!ok) return;
    await ref
        .read(appDatabaseProvider)
        .nodesDao
        .purgeOldTrash(0);
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
        actions: [
          TextButton(onPressed: _purgeAll, child: Text(l10n.purgeNow)),
        ],
      ),
      body: FutureBuilder<List<Node>>(
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
                child: Text(l10n.trashAutoPurge,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
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
      ),
    );
  }
}
