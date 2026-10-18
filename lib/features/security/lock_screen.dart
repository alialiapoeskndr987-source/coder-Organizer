import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/security_providers.dart';

/// v2.0 (D-031) — the only thing visible when the app is locked.
///
/// Two modes:
///  - password: normal app lock (D-028);
///  - totp: anti-theft hard lock after the failed-attempts limit — the
///    password field is GONE, only a 6-digit authenticator code (or a
///    one-time recovery code) opens the app. No content is ever rendered.
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitPassword() async {
    final ok =
        await ref.read(securityProvider.notifier).verifyPassword(_controller.text);
    if (!mounted) return;
    setState(() {
      _error = ok ? null : AppLocalizations.of(context)!.wrongPassword;
    });
    if (ok) _controller.clear();
  }

  Future<void> _submitTotp() async {
    final notifier = ref.read(securityProvider.notifier);
    final code = _controller.text.trim();
    var ok = code.length == 6
        ? await notifier.verifyTotpCode(code)
        : false;
    if (!ok && code.length != 6) {
      // 8+ hex chars → treat as a recovery code.
      ok = await notifier.verifyRecoveryCode(code);
    }
    if (!mounted) return;
    setState(() {
      _error = ok ? null : AppLocalizations.of(context)!.wrongCode;
    });
    if (ok) _controller.clear();
  }

  Future<void> _useRecoveryCode() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.recoveryCode),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.recoveryCode),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: Text(l10n.confirm)),
        ],
      ),
    );
    if (code == null || code.isEmpty || !mounted) return;
    final ok =
        await ref.read(securityProvider.notifier).verifyRecoveryCode(code);
    if (!mounted) return;
    setState(() {
      _error = ok ? null : AppLocalizations.of(context)!.wrongCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(securityProvider);
    final isTotp = state.lockReason == LockReason.totp;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      isTotp ? Icons.gpp_maybe_outlined : Icons.lock_outline,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      isTotp ? l10n.totpLockTitle : l10n.lockTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isTotp ? l10n.totpLockMsg : l10n.enterPassword,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 26),
                    TextField(
                      controller: _controller,
                      obscureText: !isTotp,
                      keyboardType: TextInputType.visiblePassword,
                      autofocus: true,
                      maxLength: isTotp ? 12 : null,
                      inputFormatters: isTotp
                          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z]'))]
                          : null,
                      onSubmitted: (_) =>
                          isTotp ? _submitTotp() : _submitPassword(),
                      decoration: InputDecoration(
                        labelText: isTotp ? l10n.enterTotp : l10n.appPassword,
                        counterText: '',
                        errorText: _error,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () =>
                          isTotp ? _submitTotp() : _submitPassword(),
                      icon: const Icon(Icons.key_rounded),
                      label: Text(l10n.unlock),
                    ),
                    if (isTotp) ...[
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: _useRecoveryCode,
                        icon: const Icon(Icons.remember_me_outlined, size: 18),
                        label: Text(l10n.useRecoveryCode),
                      ),
                      if (state.failedAttempts > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            l10n.lockedHint,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
