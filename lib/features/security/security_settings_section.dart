import 'package:flutter/material.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../providers/core_providers.dart';
import '../../providers/security_providers.dart';
import '../paywall/paywall_screen.dart';

/// v2.0 — password confirmation for sensitive actions (D-028: export,
/// import, permanent deletes, security changes). Returns true when the
/// action may proceed.
Future<bool> requestSensitiveAuth(
  BuildContext context,
  WidgetRef ref,
) async {
  final state = ref.read(securityProvider);
  if (!needsSensitiveAuth(state)) return true;
  final l10n = AppLocalizations.of(context)!;
  final controller = TextEditingController();
  var ok = false;
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.passwordRequiredTitle),
      content: TextField(
        controller: controller,
        obscureText: true,
        autofocus: true,
        decoration: InputDecoration(labelText: l10n.appPassword),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: () async {
            final good = await ref
                .read(securityProvider.notifier)
                .verifyPassword(controller.text);
            if (ctx.mounted) {
              if (good) {
                ok = true;
                Navigator.pop(ctx);
              } else {
                ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text(l10n.wrongPassword)));
              }
            }
          },
          child: Text(l10n.confirm),
        ),
      ],
    ),
  );
  return ok;
}

/// v2.0 — security section embedded in Settings (D-028..D-031).
///
///  - App password: set/change/remove — available to ALL users.
///  - Conditional switches (require-on-open / require-on-actions) appear
///    ONLY after a password exists, as the owner specified.
///  - Idle auto-lock with 5 fixed options (D-030).
///  - Anti-theft (TOTP authenticator + recovery codes): Pro-only (D-026).
class SecuritySettingsSection extends ConsumerWidget {
  const SecuritySettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final security = ref.watch(securityProvider);
    final trial = ref.watch(trialProvider).value;
    final isPro = trial == null || trial.purchased || trial.daysLeft > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.password_rounded),
          title: Text(security.hasPassword
              ? l10n.changeAppPassword
              : l10n.setAppPassword),
          subtitle: security.hasPassword ? Text(l10n.appPassword) : null,
          onTap: () => security.hasPassword
              ? _changePasswordFlow(context, ref)
              : _setPasswordFlow(context, ref),
        ),
        if (security.hasPassword) ...[
          SwitchListTile(
            secondary: const Icon(Icons.power_settings_new_rounded),
            title: Text(l10n.requireOnOpen),
            value: security.requireOnOpen,
            onChanged: (v) =>
                ref.read(securityProvider.notifier).setRequireOnOpen(v),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.admin_panel_settings_outlined),
            title: Text(l10n.requireOnActions),
            subtitle: Text(l10n.sensitiveHint, style: theme.textTheme.bodySmall),
            value: security.requireOnActions,
            onChanged: (v) =>
                ref.read(securityProvider.notifier).setRequireOnActions(v),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<int>(
              initialValue: security.lockTimeoutMinutes,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.autoLock),
              items: [
                for (final m in const [1, 5, 15, 30, 120])
                  DropdownMenuItem(value: m, child: Text(_lockLabel(l10n, m))),
              ],
              onChanged: (v) {
                if (v != null) {
                  ref.read(securityProvider.notifier).setLockTimeoutMinutes(v);
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.remove_circle_outline),
            title: Text(l10n.removeAppPassword,
                style: TextStyle(color: theme.colorScheme.error)),
            onTap: () => _removePasswordFlow(context, ref),
          ),
        ],
        const Divider(height: 24),
        ListTile(
          leading: Icon(
            Icons.gpp_good_outlined,
            color: isPro ? theme.colorScheme.primary : null,
          ),
          title: Row(children: [
            Expanded(child: Text(l10n.antiTheft)),
            if (!isPro)
              Icon(Icons.lock, size: 18, color: theme.colorScheme.onSurfaceVariant),
          ]),
          subtitle: Text(
            security.antiTheftEnabled
                ? l10n.antiTheftEnabledLabel
                : (isPro ? l10n.antiTheftDesc : l10n.antiTheftProNote),
            style: theme.textTheme.bodySmall,
          ),
          onTap: () async {
            if (!isPro) {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const PaywallScreen()));
              return;
            }
            if (security.antiTheftEnabled) {
              await _disableAntiTheftFlow(context, ref);
            } else {
              if (!await requestSensitiveAuth(context, ref)) return;
              if (!context.mounted) return;
              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TotpSetupScreen()));
            }
          },
        ),
        if (security.antiTheftEnabled && isPro) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<int>(
              initialValue: security.maxAttempts,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.maxAttempts),
              items: [
                for (final n in const [3, 5, 10])
                  DropdownMenuItem(
                      value: n, child: Text(l10n.attemptsOption(n))),
              ],
              onChanged: (v) {
                if (v != null) {
                  ref.read(securityProvider.notifier).setMaxAttempts(v);
                }
              },
            ),
          ),
        ],
      ],
    );
  }

  String _lockLabel(AppLocalizations l10n, int minutes) => switch (minutes) {
        1 => l10n.lock1m,
        5 => l10n.lock5m,
        15 => l10n.lock15m,
        30 => l10n.lock30m,
        120 => l10n.lock2h,
        _ => '$minutes',
      };

  Future<void> _setPasswordFlow(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final next = TextEditingController();
    final next2 = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.setAppPassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: next,
                obscureText: true,
                decoration:
                    InputDecoration(labelText: l10n.newPassword)),
            const SizedBox(height: 10),
            TextField(
                controller: next2,
                obscureText: true,
                decoration:
                    InputDecoration(labelText: l10n.confirmPassword)),
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
    if (ok != true || !context.mounted) return;
    if (next.text.length < AppConstants.minPasswordLength ||
        next.text != next2.text) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.passwordShort)));
      }
      return;
    }
    await ref.read(securityProvider.notifier).setAppPassword(next.text);
    // Sensible default per owner spec: ask on every open.
    await ref.read(securityProvider.notifier).setRequireOnOpen(true);
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.saved)));
    }
  }

  Future<void> _changePasswordFlow(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final current = TextEditingController();
    final next = TextEditingController();
    final next2 = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.changeAppPassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: current,
                obscureText: true,
                decoration:
                    InputDecoration(labelText: l10n.currentPassword)),
            const SizedBox(height: 10),
            TextField(
                controller: next,
                obscureText: true,
                decoration:
                    InputDecoration(labelText: l10n.newPassword)),
            const SizedBox(height: 10),
            TextField(
                controller: next2,
                obscureText: true,
                decoration:
                    InputDecoration(labelText: l10n.confirmPassword)),
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
    if (ok != true || !context.mounted) return;
    if (next.text.length < AppConstants.minPasswordLength ||
        next.text != next2.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.passwordShort)));
      return;
    }
    try {
      await ref
          .read(securityProvider.notifier)
          .changeAppPassword(current.text, next.text);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.saved)));
      }
    } on SecurityException {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.wrongPassword)));
      }
    }
  }

  Future<void> _removePasswordFlow(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.removeAppPassword),
        content: Text(l10n.removePasswordWarn),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    if (!await requestSensitiveAuth(context, ref)) return;
    await ref.read(securityProvider.notifier).removeAppPassword();
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.saved)));
    }
  }

  Future<void> _disableAntiTheftFlow(
      BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    if (!await requestSensitiveAuth(context, ref)) return;
    if (!context.mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.disableAntiTheft),
        content: Text(l10n.removePasswordWarn),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.confirm)),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(securityProvider.notifier).disableAntiTheft();
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.saved)));
    }
  }
}
