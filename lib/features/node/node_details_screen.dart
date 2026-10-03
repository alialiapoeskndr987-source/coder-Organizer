import 'package:collection/collection.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/models/enums.dart';
import '../../data/db/app_database.dart';
import '../../providers/core_providers.dart';
import '../../providers/tree_providers.dart';
import '../../shared/widgets/common.dart';
import '../../shared/widgets/icon_registry.dart';
import 'node_element_dialogs.dart';

/// Node details (FR-06): links, notes (≤50, D-007), alerts, registered
/// emails, subscriptions, publishing platforms and variables.
class NodeDetailsScreen extends ConsumerWidget {
  final int nodeId;
  const NodeDetailsScreen({super.key, required this.nodeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final tree = ref.watch(treeProvider).value;
    final node = tree?.nodes.where((n) => n.id == nodeId).firstOrNull;
    if (node == null) {
      return Scaffold(
        appBar: AppBar(),
        body: EmptyState(icon: Icons.search_off, message: l10n.noResults),
      );
    }
    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(node.name),
        actions: [
          IconButton(
            tooltip: l10n.changeIcon,
            icon: Icon(iconFor(node.icon)),
            onPressed: () async {
              final picked = await pickIconDialog(context, node.icon);
              if (picked != null) {
                await ref.read(nodeActionsProvider).updateNode(
                    node.id, NodesCompanion(icon: Value(picked)));
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(iconFor(node.icon),
                      size: 40, color: theme.colorScheme.primary),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(node.name,
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            Chip(
                              label: Text(nodeTypeLabel(l10n, node.type),
                                  style: const TextStyle(fontSize: 12)),
                              visualDensity: VisualDensity.compact,
                            ),
                            if (node.template != null)
                              Chip(
                                label: Text(
                                    templateLabel(l10n, node.template!),
                                    style: const TextStyle(fontSize: 12)),
                                visualDensity: VisualDensity.compact,
                                backgroundColor:
                                    theme.colorScheme.secondaryContainer,
                              ),
                            if (node.status == NodeStatus.archived)
                              Chip(
                                label: Text(l10n.statusArchived,
                                    style: const TextStyle(fontSize: 12)),
                                visualDensity: VisualDensity.compact,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _LinksSection(db: db, nodeId: nodeId),
          _NotesSection(db: db, nodeId: nodeId),
          _AlertsSection(db: db, nodeId: nodeId),
          _EmailsSection(db: db, nodeId: nodeId),
          _SubscriptionsSection(db: db, nodeId: nodeId),
          _PlatformsSection(db: db, nodeId: nodeId),
          _VariablesSection(db: db, nodeId: nodeId),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

typedef AddGuard = Future<void> Function(BuildContext, WidgetRef, VoidCallback);

Future<void> _guardedAdd(
  BuildContext context,
  WidgetRef ref,
  VoidCallback open,
) async {
  if (!await PaywallGate.ensure(context, ref)) return;
  open();
}

// ── Links ─────────────────────────────────────────────────────────────
class _LinksSection extends ConsumerWidget {
  final AppDatabase db;
  final int nodeId;
  const _LinksSection({required this.db, required this.nodeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Column(children: [
      SectionHeader(
        title: l10n.links,
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: l10n.addLink,
          onPressed: () =>
              _guardedAdd(context, ref, () => showLinkDialog(context, ref, nodeId: nodeId)),
        ),
      ),
      StreamBuilder<List<Link>>(
        stream: db.elementsDao.watchLinks(nodeId),
        builder: (context, snap) {
          final items = snap.data ?? const [];
          if (items.isEmpty) {
            return Text('—', style: theme.textTheme.bodySmall);
          }
          return Column(
            children: [
              for (final link in items)
                ListTile(
                  leading: const Icon(Icons.link),
                  title: Text(link.title),
                  subtitle: Text(link.url,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: _elementMenu(
                    context,
                    onEdit: () => showLinkDialog(context, ref,
                        nodeId: nodeId, existing: link),
                    onDelete: () => deleteElementWithUndo(context, ref,
                        type: ElementType.link, id: link.id),
                  ),
                  onTap: () async {
                    final raw = link.url.startsWith('http')
                        ? link.url
                        : 'https://${link.url}';
                    try {
                      await launchUrl(Uri.parse(raw),
                          mode: LaunchMode.externalApplication);
                    } catch (_) {
                      if (context.mounted) {
                        showError(context, l10n.urlInvalid);
                      }
                    }
                  },
                ),
            ],
          );
        },
      ),
    ]);
  }
}

Widget _elementMenu(BuildContext context,
    {required VoidCallback onEdit, required VoidCallback onDelete}) {
  final l10n = AppLocalizations.of(context)!;
  return PopupMenuButton<String>(
    onSelected: (v) => switch (v) {
      'edit' => onEdit(),
      'delete' => onDelete(),
      _ => {},
    },
    itemBuilder: (ctx) => [
      PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
      PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
    ],
  );
}

// ── Notes (carousel with navigation, ≤50 — D-007) ─────────────────────
class _NotesSection extends ConsumerWidget {
  final AppDatabase db;
  final int nodeId;
  const _NotesSection({required this.db, required this.nodeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Column(children: [
      SectionHeader(
        title: l10n.notes,
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: l10n.addNote,
          onPressed: () =>
              _guardedAdd(context, ref, () => showNoteDialog(context, ref, nodeId: nodeId)),
        ),
      ),
      StreamBuilder<List<Note>>(
        stream: db.elementsDao.watchNotes(nodeId),
        builder: (context, snap) {
          final notes = snap.data ?? const [];
          if (notes.isEmpty) {
            return const Text('—');
          }
          return _NotesCarousel(notes: notes, nodeId: nodeId);
        },
      ),
    ]);
  }
}

class _NotesCarousel extends ConsumerStatefulWidget {
  final List<Note> notes;
  final int nodeId;
  const _NotesCarousel({required this.notes, required this.nodeId});

  @override
  ConsumerState<_NotesCarousel> createState() => _NotesCarouselState();
}

class _NotesCarouselState extends ConsumerState<_NotesCarousel> {
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final notes = widget.notes;
    return SizedBox(
      height: 190,
      child: Column(children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: notes.length,
            itemBuilder: (context, i) {
              final note = notes[i];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              note.title ?? l10n.noteOf(i + 1, notes.length),
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _elementMenu(
                            context,
                            onEdit: () => showNoteDialog(context, ref,
                                nodeId: widget.nodeId, existing: note),
                            onDelete: () => deleteElementWithUndo(context, ref,
                                type: ElementType.note, id: note.id),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Text(
                          note.content,
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        ),
                      ),
                      Text(
                        '${i + 1} / ${notes.length}',
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}

// ── Alerts ────────────────────────────────────────────────────────────
class _AlertsSection extends ConsumerWidget {
  final AppDatabase db;
  final int nodeId;
  const _AlertsSection({required this.db, required this.nodeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Column(children: [
      SectionHeader(
        title: l10n.alertsWithCount,
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: l10n.addAlert,
          onPressed: () =>
              _guardedAdd(context, ref, () => showAlertDialog(context, ref, nodeId: nodeId)),
        ),
      ),
      StreamBuilder<List<Alert>>(
        stream: db.elementsDao.watchAlerts(nodeId),
        builder: (context, snap) {
          final items = snap.data ?? const [];
          if (items.isEmpty) {
            return Text('—', style: theme.textTheme.bodySmall);
          }
          return Column(
            children: [
              for (final alert in items)
                ListTile(
                  leading: Icon(
                    alert.enabled ? Icons.alarm_on_outlined : Icons.alarm_off,
                    color: alert.enabled
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  title: Text(alert.title),
                  subtitle: Text(
                    '${alert.fireAt.toString().substring(0, 16)} · ${reminderLabel(l10n, alert.reminderMinutesBefore)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: alert.enabled,
                        onChanged: (v) => ref.read(elementActionsProvider).updateAlert(
                              alert.id,
                              AlertsCompanion.insert(
                                nodeId: alert.nodeId,
                                title: alert.title,
                                fireAt: alert.fireAt,
                                reminderMinutesBefore:
                                    Value(alert.reminderMinutesBefore),
                                enabled: Value(v),
                              ),
                            ),
                      ),
                      _elementMenu(
                        context,
                        onEdit: () => showAlertDialog(context, ref,
                            nodeId: nodeId, existing: alert),
                        onDelete: () => deleteElementWithUndo(context, ref,
                            type: ElementType.alert, id: alert.id),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    ]);
  }
}

// ── Registered emails ─────────────────────────────────────────────────
class _EmailsSection extends ConsumerWidget {
  final AppDatabase db;
  final int nodeId;
  const _EmailsSection({required this.db, required this.nodeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Column(children: [
      SectionHeader(
        title: l10n.registeredEmails,
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: l10n.addEmail,
          onPressed: () =>
              _guardedAdd(context, ref, () => showEmailDialog(context, ref, nodeId: nodeId)),
        ),
      ),
      StreamBuilder<List<Email>>(
        stream: db.elementsDao.watchEmails(nodeId),
        builder: (context, snap) {
          final items = snap.data ?? const [];
          if (items.isEmpty) {
            return Text('—', style: theme.textTheme.bodySmall);
          }
          return Column(
            children: [
              for (final email in items) _EmailTile(email: email),
            ],
          );
        },
      ),
    ]);
  }
}

class _EmailTile extends ConsumerStatefulWidget {
  final Email email;
  const _EmailTile({required this.email});

  @override
  ConsumerState<_EmailTile> createState() => _EmailTileState();
}

class _EmailTileState extends ConsumerState<_EmailTile> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final e = widget.email;
    return ListTile(
      leading: const Icon(Icons.alternate_email),
      title: Text('${e.label} · ${e.address}'),
      subtitle: e.password == null
          ? null
          : Text(
              _revealed ? e.password! : '••••••••',
              style: theme.textTheme.bodySmall,
            ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (e.password != null)
            IconButton(
              icon: Icon(_revealed
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
              onPressed: () => setState(() => _revealed = !_revealed),
              tooltip: _revealed ? l10n.hideSecret : l10n.showSecret,
            ),
          _elementMenu(
            context,
            onEdit: () => showEmailDialog(context, ref,
                nodeId: e.nodeId, existing: e),
            onDelete: () => deleteElementWithUndo(context, ref,
                type: ElementType.email, id: e.id),
          ),
        ],
      ),
    );
  }
}

// ── Subscriptions ─────────────────────────────────────────────────────
class _SubscriptionsSection extends ConsumerWidget {
  final AppDatabase db;
  final int nodeId;
  const _SubscriptionsSection({required this.db, required this.nodeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Column(children: [
      SectionHeader(
        title: l10n.subscriptions,
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: l10n.addSubscription,
          onPressed: () => _guardedAdd(
              context, ref, () => showSubscriptionDialog(context, ref, nodeId: nodeId)),
        ),
      ),
      StreamBuilder<List<Subscription>>(
        stream: db.elementsDao.watchSubscriptions(nodeId),
        builder: (context, snap) {
          final items = snap.data ?? const [];
          if (items.isEmpty) {
            return Text('—', style: theme.textTheme.bodySmall);
          }
          return Column(
            children: [
              for (final s in items)
                ListTile(
                  leading: const Icon(Icons.subscriptions_outlined),
                  title: Text(s.serviceName +
                      (s.plan == null || s.plan!.isEmpty ? '' : ' · ${s.plan}')),
                  subtitle: Text(
                    '${s.price ?? ''}${s.price == null || s.price!.isEmpty ? '' : ' · '}${cycleLabel(l10n, s.cycle)}${s.renewsAt != null ? ' · ${l10n.subRenewsAt} ${s.renewsAt.toString().substring(0, 10)}' : ''}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Chip(
                        label: Text(subStatusLabel(l10n, s.status),
                            style: const TextStyle(fontSize: 11)),
                        visualDensity: VisualDensity.compact,
                      ),
                      _elementMenu(
                        context,
                        onEdit: () => showSubscriptionDialog(context, ref,
                            nodeId: nodeId, existing: s),
                        onDelete: () => deleteElementWithUndo(context, ref,
                            type: ElementType.subscription, id: s.id),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    ]);
  }
}

// ── Publishing platforms ──────────────────────────────────────────────
class _PlatformsSection extends ConsumerWidget {
  final AppDatabase db;
  final int nodeId;
  const _PlatformsSection({required this.db, required this.nodeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Column(children: [
      SectionHeader(
        title: l10n.platforms,
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: l10n.addPlatform,
          onPressed: () =>
              _guardedAdd(context, ref, () => showPlatformDialog(context, ref, nodeId: nodeId)),
        ),
      ),
      StreamBuilder<List<PlatformRow>>(
        stream: db.elementsDao.watchPlatforms(nodeId),
        builder: (context, snap) {
          final items = snap.data ?? const [];
          if (items.isEmpty) {
            return Text('—', style: theme.textTheme.bodySmall);
          }
          return Column(
            children: [
              for (final p in items)
                ListTile(
                  leading: const Icon(Icons.storefront_outlined),
                  title: Text(p.platformName),
                  subtitle: Text([p.account, p.url]
                      .whereType<String>()
                      .where((s) => s.isNotEmpty)
                      .join(' · ')),
                  trailing: _elementMenu(
                    context,
                    onEdit: () => showPlatformDialog(context, ref,
                        nodeId: nodeId, existing: p),
                    onDelete: () => deleteElementWithUndo(context, ref,
                        type: ElementType.platform, id: p.id),
                  ),
                ),
            ],
          );
        },
      ),
    ]);
  }
}

// ── Variables ─────────────────────────────────────────────────────────
class _VariablesSection extends ConsumerWidget {
  final AppDatabase db;
  final int nodeId;
  const _VariablesSection({required this.db, required this.nodeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Column(children: [
      SectionHeader(
        title: l10n.variables,
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: l10n.addVariable,
          onPressed: () =>
              _guardedAdd(context, ref, () => showVariableDialog(context, ref, nodeId: nodeId)),
        ),
      ),
      StreamBuilder<List<VariableRow>>(
        stream: db.elementsDao.watchVariables(nodeId),
        builder: (context, snap) {
          final items = snap.data ?? const [];
          if (items.isEmpty) {
            return Text('—', style: theme.textTheme.bodySmall);
          }
          return Column(
            children: [
              for (final v in items)
                ListTile(
                  leading: Icon(
                      v.isSecret ? Icons.key : Icons.data_object,
                      color: v.isSecret ? theme.colorScheme.secondary : null),
                  title: Text(v.varKey),
                  subtitle: Text(
                      v.isSecret ? '••••••••' : v.varValue,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  trailing: _elementMenu(
                    context,
                    onEdit: () => showVariableDialog(context, ref,
                        nodeId: nodeId, existing: v),
                    onDelete: () => deleteElementWithUndo(context, ref,
                        type: ElementType.variable, id: v.id),
                  ),
                ),
            ],
          );
        },
      ),
    ]);
  }
}
