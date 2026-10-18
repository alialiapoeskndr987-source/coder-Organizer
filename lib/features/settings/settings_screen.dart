import 'package:flutter/material.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/models/enums.dart';
import '../../core/theme/app_theme.dart';
import '../../data/db/app_database.dart';
import '../../providers/core_providers.dart';
import '../../providers/profile_providers.dart';
import '../../providers/settings_providers.dart';
import '../../shared/widgets/common.dart';
import '../paywall/paywall_screen.dart';
import '../profiles/profiles_screen.dart';
import '../security/security_settings_section.dart';
import '../trash/trash_screen.dart';

/// FR-02 owner settings: themes (8, instant), main title, language,
/// export/import (SAF), account, analytics consent, about.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final currentTheme = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    final mainTitle = ref.watch(mainTitleProvider);
    final isFirebase = ref.read(authServiceProvider).isFirebaseBacked;
    final consent = ref.watch(analyticsConsentProvider);
    final trial = ref.watch(trialProvider).value;
    final isPro = trial == null || trial.purchased || trial.daysLeft > 0;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // v2.0 (D-021) — profiles: quick switcher + management entry.
          SectionHeader(title: l10n.profiles),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(l10n.manageProfiles),
            subtitle: Text(l10n.profilesProNote, style: theme.textTheme.bodySmall),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const ProfilesScreen(),
            )),
          ),
          SectionHeader(title: l10n.mainTitleLabel),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              initialValue: mainTitle,
              maxLength: AppConstants.mainTitleMaxLength,
              decoration:
                  InputDecoration(hintText: l10n.mainTitleHint, counterText: ''),
              onChanged: (v) =>
                  ref.read(mainTitleProvider.notifier).setTitle(v.trim()),
            ),
          ),

          SectionHeader(title: l10n.themes),
          SizedBox(
            height: 128,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: AppTheme.values.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final t = AppTheme.values[i];
                final p = t.preset;
                final selected = t == currentTheme;
                return GestureDetector(
                  onTap: () {
                    // v2.0 (D-026) — theme changes are Pro-only.
                    if (!isPro) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const PaywallScreen()));
                      return;
                    }
                    ref.read(themeProvider.notifier).setTheme(t);
                  },
                  child: Container(
                    width: 108,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(p.background),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected
                            ? Color(p.primary)
                            : theme.colorScheme.outline.withValues(alpha: 0.5),
                        width: selected ? 2.5 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          _dot(Color(p.primary)),
                          const SizedBox(width: 6),
                          _dot(Color(p.accent)),
                          const Spacer(),
                          // v2.0 — lock badge on every theme for free users.
                          if (!isPro)
                            Icon(Icons.lock,
                                size: 14,
                                color: Color(p.primary)
                                    .withValues(alpha: 0.8)),
                        ]),
                        const Spacer(),
                        Text(
                          themeName(AppLocalizations.of(context)!, t),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(p.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          SectionHeader(title: l10n.language),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'en', label: Text('English')),
                ButtonSegment(value: 'ar', label: Text('العربية')),
              ],
              selected: {locale?.languageCode ?? 'en'},
              onSelectionChanged: (s) =>
                  ref.read(localeProvider.notifier).setLocale(
                        s.first == 'en' ? const Locale('en') : const Locale('ar'),
                      ),
            ),
          ),

          SectionHeader(title: l10n.organizationSection),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<NodeSort>(
              // v1.23 — default ordering for tree browser & search.
              initialValue: ref.watch(nodeSortProvider),
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.defaultSort),
              items: [
                DropdownMenuItem(
                    value: NodeSort.manual, child: Text(l10n.sortManual)),
                DropdownMenuItem(
                    value: NodeSort.nameAZ, child: Text(l10n.sortNameAZ)),
                DropdownMenuItem(
                    value: NodeSort.newest, child: Text(l10n.sortNewest)),
                DropdownMenuItem(
                    value: NodeSort.oldest, child: Text(l10n.sortOldest)),
              ],
              onChanged: (v) {
                if (v != null) {
                  ref.read(nodeSortProvider.notifier).setSort(v);
                }
              },
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.insights_outlined),
            title: Text(l10n.showStats),
            value: ref.watch(homePrefsProvider).showStats,
            onChanged: (v) =>
                ref.read(homePrefsProvider.notifier).setShowStats(v),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.grid_view_outlined),
            title: Text(l10n.compactGrid),
            value: ref.watch(homePrefsProvider).compactGrid,
            onChanged: (v) =>
                ref.read(homePrefsProvider.notifier).setCompactGrid(v),
          ),

          // v2.0 (D-028..D-031) — security & anti-theft.
          SectionHeader(title: l10n.securitySection),
          const SecuritySettingsSection(),

          // v2.0 (D-023) — editable category names for the current profile.
          SectionHeader(
            title: l10n.editCategories,
            trailing: Text(l10n.categoryFixedNote,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant)),
          ),
          const _EditableCategories(),

          SectionHeader(title: l10n.dataSection),
          ListTile(
            leading: const Icon(Icons.ios_share),
            title: Text(l10n.exportData),
            onTap: () async {
              // v2.0 (D-028) — optional password gate on sensitive actions.
              if (!await requestSensitiveAuth(context, ref)) return;
              final ok =
                  await ref.read(importExportProvider).exportToFile();
              if (context.mounted) {
                showError(context, ok ? l10n.exportDone : l10n.dataError);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_open_outlined),
            title: Text(l10n.importData),
            onTap: () => _importFlow(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: Text(l10n.trash),
            subtitle: Text(l10n.trashAutoPurge,
                style: theme.textTheme.bodySmall),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TrashScreen()),
            ),
          ),

          if (isFirebase) ...[
            SectionHeader(title: l10n.accountSection),
            ListTile(
              leading: const Icon(Icons.lock_reset_outlined),
              title: Text(l10n.changePassword),
              onTap: () => _changePasswordDialog(context, ref),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(l10n.logout),
              onTap: () async {
                await ref.read(authProvider.notifier).signOut();
                if (context.mounted) {
                  Navigator.of(context).popUntil((r) => r.isFirst);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_forever,
                  color: theme.colorScheme.error),
              title: Text(l10n.deleteMyAccount,
                  style: TextStyle(color: theme.colorScheme.error)),
              onTap: () async {
                final ok = await confirmDialog(
                  context,
                  title: l10n.deleteMyAccount,
                  message: l10n.deleteAccountConfirm,
                  destructive: true,
                );
                if (!ok) return;
                await ref.read(authProvider.notifier).deleteAccount();
                await ref.read(authProvider.notifier).signOut();
              },
            ),
          ],

          SectionHeader(title: l10n.analyticsSection),
          SwitchListTile(
            secondary: const Icon(Icons.query_stats_outlined),
            title: Text(consent ? l10n.analyticsOn : l10n.analyticsOff),
            subtitle: Text(l10n.analyticsDesc,
                style: theme.textTheme.bodySmall),
            value: consent,
            onChanged: (v) async {
              ref.read(analyticsConsentProvider.notifier).state = v;
              await ref
                  .read(appDatabaseProvider)
                  .setSetting('analytics_consent', v ? '1' : '0');
            },
          ),

          SectionHeader(title: l10n.aboutSection),
          ListTile(
            leading: const Icon(Icons.terminal),
            title: Text(AppConstants.appDisplayName),
            subtitle: Text('${l10n.version} ${AppConstants.appVersion}'),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color c) => Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      );

  Future<void> _importFlow(BuildContext context, WidgetRef ref) async {
    // v2.0 (D-028) — optional password gate on sensitive actions.
    if (!await requestSensitiveAuth(context, ref)) return;
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final service = ref.read(importExportProvider);
    final decoded = await service.pickAndDecode();
    if (decoded == null) return;
    if (!context.mounted) return;

    var strategy = ImportStrategy.merge;
    final c = decoded.counts;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.importData),
        content: StatefulBuilder(
          builder: (ctx, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.importPreview(
                c['nodes'] ?? 0,
                c['links'] ?? 0,
                c['notes'] ?? 0,
                c['emails'] ?? 0,
                c['subscriptions'] ?? 0,
                c['platforms'] ?? 0,
                c['variables'] ?? 0,
                c['alerts'] ?? 0,
              )),
              const SizedBox(height: 14),
              RadioListTile<ImportStrategy>(
                title: Text(l10n.strategyMerge),
                value: ImportStrategy.merge,
                groupValue: strategy,
                onChanged: (v) => setState(() => strategy = v!),
              ),
              RadioListTile<ImportStrategy>(
                title: Text(l10n.strategyReplace),
                value: ImportStrategy.replace,
                groupValue: strategy,
                onChanged: (v) => setState(() => strategy = v!),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.importData)),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await service.applyImport(decoded.data, strategy);
      // Reschedule alerts after data changed (FR-06).
      final alerts =
          await ref.read(appDatabaseProvider).elementsDao.allEnabledAlerts();
      await ref.read(notificationsProvider).rescheduleAll(alerts);
      if (context.mounted) showError(context, l10n.importDone);
    } catch (e) {
      if (context.mounted) showError(context, l10n.dataError);
    }
  }

  Future<void> _changePasswordDialog(
      BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final current = TextEditingController();
    final next = TextEditingController();
    final next2 = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.changePassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: current,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.currentPassword),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: next,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.newPassword),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: next2,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.confirmPassword),
            ),
          ],
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
    if (next.text != next2.text || next.text.length < AppConstants.minPasswordLength) {
      if (context.mounted) showError(context, l10n.passwordShort);
      return;
    }
    try {
      await ref
          .read(authProvider.notifier)
          .changePassword(current.text, next.text);
      if (context.mounted) showError(context, l10n.save);
    } catch (e) {
      if (context.mounted) showError(context, l10n.authError);
    }
  }
}

/// v2.0 (D-023) — the current profile's 10 editable catalog entries
/// (numbers 41..50, hidden). Only the display name is user-settable.
class _EditableCategories extends ConsumerWidget {
  const _EditableCategories();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final profileId = ref.watch(currentProfileIdProvider);
    final catsAsync = ref.watch(categoriesProvider(profileId));
    final editable = (catsAsync.value ?? const <CategoryRow>[])
        .where((c) => c.isEditable)
        .toList();

    return Column(
      children: [
        for (final c in editable)
          ListTile(
            dense: true,
            leading: Icon(Icons.label_outline,
                size: 20, color: theme.colorScheme.primary),
            title: Text(categoryDisplayName(l10n, c)),
            subtitle: Text(l10n.categoryNumber(c.number),
                style: theme.textTheme.bodySmall),
            trailing: const Icon(Icons.edit_outlined, size: 18),
            onTap: () async {
              final controller = TextEditingController(text: c.name ?? '');
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.renameCategory),
                  content: TextField(
                    controller: controller,
                    autofocus: true,
                    maxLength: 60,
                    decoration:
                        InputDecoration(labelText: l10n.categoryName),
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
              await ref
                  .read(appDatabaseProvider)
                  .renameCategory(c.id, name);
            },
          ),
      ],
    );
  }
}
