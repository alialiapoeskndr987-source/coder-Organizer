import 'package:flutter/material.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../providers/core_providers.dart';
import '../../providers/tree_providers.dart';
import '../../shared/widgets/common.dart';
import '../node/node_details_screen.dart';

/// Alerts center (SRS screens list): upcoming / fired / disabled views.
class AlertsCenterScreen extends ConsumerWidget {
  const AlertsCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final db = ref.watch(appDatabaseProvider);
    final tree = ref.watch(treeProvider).value;
    final nodeNames = tree == null
        ? const <int, String>{}
        : {for (final n in tree.nodes) n.id: n.name};

    return Scaffold(
      appBar: AppBar(title: Text(l10n.alertsCenter)),
      body: StreamBuilder<List<Alert>>(
        stream: db.elementsDao.watchAllAlerts(),
        builder: (context, snap) {
          final alerts = snap.data ?? const [];
          final now = DateTime.now();
          final upcoming =
              alerts.where((a) => a.enabled && a.fireAt.isAfter(now)).toList()
                ..sort((a, b) => a.fireAt.compareTo(b.fireAt));
          final fired =
              alerts.where((a) => a.enabled && !a.fireAt.isAfter(now)).toList()
                ..sort((a, b) => b.fireAt.compareTo(a.fireAt));
          final disabled = alerts.where((a) => !a.enabled).toList()
            ..sort((a, b) => b.fireAt.compareTo(a.fireAt));

          if (alerts.isEmpty) {
            return EmptyState(icon: Icons.notifications_none, message: l10n.noAlerts);
          }

          Widget group(String title, List<Alert> items, IconData icon) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: title),
                  for (final a in items)
                    ListTile(
                      leading: Icon(icon, color: theme.colorScheme.primary),
                      title: Text(a.title),
                      subtitle: Text(
                        '${nodeNames[a.nodeId] ?? '—'} · ${a.fireAt.toString().substring(0, 16)}',
                      ),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => NodeDetailsScreen(nodeId: a.nodeId)),
                      ),
                    ),
                ],
              );

          return ListView(
            children: [
              group(l10n.upcoming, upcoming, Icons.schedule),
              group(l10n.fired, fired, Icons.notifications_active_outlined),
              group(l10n.alertDisabled, disabled, Icons.alarm_off),
            ],
          );
        },
      ),
    );
  }
}
