import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../providers/profile_providers.dart';
import '../profiles/profiles_screen.dart';

/// v2.0 (D-021) — quick profile switcher for the Home app bar and the
/// Settings header. Switching re-scopes every live query (treeProvider
/// watches currentProfileIdProvider).
class ProfileSwitcher extends ConsumerWidget {
  const ProfileSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profilesAsync = ref.watch(profilesProvider);
    final currentId = ref.watch(currentProfileIdProvider);
    final profiles = profilesAsync.value ?? const <Profile>[];
    final current =
        profiles.where((p) => p.id == currentId).firstOrNull ?? profiles.firstOrNull;

    return PopupMenuButton<String>(
      tooltip: l10n.profiles,
      onSelected: (v) {
        if (v == '__manage') {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfilesScreen()));
          return;
        }
        final id = int.tryParse(v);
        if (id != null) {
          ref.read(currentProfileIdProvider.notifier).switchTo(id);
        }
      },
      itemBuilder: (ctx) => [
        for (final p in profiles)
          PopupMenuItem(
            value: '${p.id}',
            child: Row(children: [
              Icon(
                p.id == currentId
                    ? Icons.check_circle
                    : Icons.person_outline,
                size: 18,
                color: p.id == currentId
                    ? Theme.of(ctx).colorScheme.primary
                    : Theme.of(ctx).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(p.name, overflow: TextOverflow.ellipsis)),
            ]),
          ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: '__manage',
          height: 44,
          child: Row(children: [
            Icon(Icons.settings_suggest_outlined,
                size: 18, color: Theme.of(ctx).colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.manageProfiles)),
          ]),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_outline, size: 20),
            const SizedBox(width: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 110),
              child: Text(
                current?.name ?? l10n.profiles,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }
}
