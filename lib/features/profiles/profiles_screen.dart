import 'package:flutter/material.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../data/db/app_database.dart';
import '../../providers/core_providers.dart';
import '../../providers/profile_providers.dart';
import '../../shared/widgets/common.dart';

/// v2.0 (D-021/D-024) — manage up to 10 profiles (Pro) / 1 (free):
/// create, rename, switch, delete-to-trash, restore, permanent delete,
/// empty the profile trash.
class ProfilesScreen extends ConsumerStatefulWidget {
  const ProfilesScreen({super.key});

  @override
  ConsumerState<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends ConsumerState<ProfilesScreen> {
  List<Profile>? _trashed;

  @override
  void initState() {
    super.initState();
    _reloadTrash();
  }

  Future<void> _reloadTrash() async {
    final list = await ref.read(appDatabaseProvider).trashedProfiles();
    if (mounted) setState(() => _trashed = list);
  }

  Future<void> _switchTo(Profile p) async {
    await ref.read(profileActionsProvider).switchTo(p.id);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _addProfile() async {
    final l10n = AppLocalizations.of(context)!;
    final trial = ref.read(trialProvider).value;
    final isPro = trial == null || trial.purchased || trial.daysLeft > 0;
    final count = await ref.read(appDatabaseProvider).activeProfileCount();
    final limit = isPro ? AppConstants.maxProfilesPro : AppConstants.maxProfilesFree;
    if (count >= limit) {
      if (!mounted) return;
      showError(
          context,
          isPro
              ? l10n.profilesProNote
              : l10n.profileLimitReached);
      return;
    }
    if (!mounted) return;
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addProfile),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 60,
          decoration: InputDecoration(labelText: l10n.profileName),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.create)),
        ],
      ),
    );
    if (ok != true) return;
    final name = controller.text.trim();
    if (name.isEmpty || !mounted) return;
    final id = await ref.read(profileActionsProvider).create(name);
    await ref.read(profileActionsProvider).switchTo(id);
    if (mounted) setState(() {});
  }

  Future<void> _renameProfile(Profile p) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: p.name);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.renameNode),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 60,
          decoration: InputDecoration(labelText: l10n.profileName),
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
    if (ok != true) return;
    final name = controller.text.trim();
    if (name.isEmpty) return;
    await ref.read(profileActionsProvider).rename(p.id, name);
    if (mounted) setState(() {});
  }

  Future<void> _deleteProfile(Profile p) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await confirmDialog(
      context,
      title: l10n.deleteProfile,
      message: l10n.deleteProfileWarn,
      destructive: true,
    );
    if (!ok) return;
    await ref.read(profileActionsProvider).deleteToTrash(p.id);
    await _reloadTrash();
    if (mounted) showError(context, l10n.profileTrashed);
  }

  Future<void> _restoreProfile(Profile p) async {
    await ref.read(profileActionsProvider).restore(p.id);
    await _reloadTrash();
    if (mounted) showError(context, l10n.profileRestored);
  }

  Future<void> _deleteForever(Profile p) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await confirmDialog(
      context,
      title: l10n.deleteForever,
      message: l10n.purgeConfirm,
      destructive: true,
    );
    if (!ok) return;
    await ref.read(profileActionsProvider).deleteForever(p.id);
    await _reloadTrash();
  }

  Future<void> _emptyTrash() async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await confirmDialog(
      context,
      title: l10n.purgeProfiles,
      message: l10n.purgeConfirm,
      destructive: true,
    );
    if (!ok) return;
    await ref.read(profileActionsProvider).emptyTrash();
    await _reloadTrash();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final profilesAsync = ref.watch(profilesProvider);
    final currentId = ref.watch(currentProfileIdProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profiles)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addProfile,
        icon: const Icon(Icons.add),
        label: Text(l10n.addProfile),
      ),
      body: profilesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            EmptyState(icon: Icons.error_outline, message: l10n.unexpectedError),
        data: (profiles) => ListView(
          padding: const EdgeInsets.only(bottom: 96),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(l10n.profilesProNote,
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant)),
            ),
            for (final p in profiles)
              Card(
                child: ListTile(
                  leading: Icon(
                    p.id == currentId
                        ? Icons.check_circle
                        : Icons.person_outline,
                    color: p.id == currentId
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  title: Text(p.name),
                  subtitle: p.id == currentId ? Text(l10n.currentProfile) : null,
                  trailing: PopupMenuButton<String>(
                    onSelected: (v) => switch (v) {
                      'rename' => _renameProfile(p),
                      'switch' => _switchTo(p),
                      'delete' => _deleteProfile(p),
                      _ => {},
                    },
                    itemBuilder: (ctx) => [
                      if (p.id != currentId)
                        PopupMenuItem(
                            value: 'switch', child: Text(l10n.switchTo)),
                      PopupMenuItem(
                          value: 'rename', child: Text(l10n.renameNode)),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(l10n.deleteProfile,
                            style:
                                TextStyle(color: theme.colorScheme.error)),
                      ),
                    ],
                  ),
                  onTap: () => _switchTo(p),
                ),
              ),
            const SizedBox(height: 12),
            if (_trashed != null && _trashed!.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  Expanded(
                    child: Text(l10n.profilesTrash,
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700)),
                  ),
                  TextButton(
                      onPressed: _emptyTrash, child: Text(l10n.purgeProfiles)),
                ]),
              ),
              for (final p in _trashed!)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.delete_outline),
                    title: Text(p.name),
                    subtitle: Text(
                        p.deletedAt?.toString().substring(0, 10) ?? ''),
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
                          onPressed: () => _deleteForever(p),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
