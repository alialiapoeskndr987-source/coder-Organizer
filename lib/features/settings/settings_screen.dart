import 'package:flutter/material.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/models/enums.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/core_providers.dart';
import '../../providers/settings_providers.dart';
import '../../shared/widgets/common.dart';
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
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
                  onTap: () => ref.read(themeProvider.notifier).setTheme(t),
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

          SectionHeader(title: l10n.dataSection),
          ListTile(
            leading: const Icon(Icons.ios_share),
            title: Text(l10n.exportData),
            onTap: () async {
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
