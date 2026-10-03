import 'package:flutter/material.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../providers/core_providers.dart';
import '../../shared/widgets/common.dart';
import '../home/home_shell.dart';

enum _AuthMode { login, register, forgot }

/// FR-01 — email+password (8+ chars, strength meter) + Google Sign-In +
/// secure password reset (60-minute link, D-006).
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  _AuthMode _mode = _AuthMode.login;
  bool _busy = false;
  bool _obscure = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  int _strength(String p) {
    var score = 0;
    if (p.length >= AppConstants.minPasswordLength) score++;
    if (p.contains(RegExp(r'[A-Z]'))) score++;
    if (p.contains(RegExp(r'[0-9]'))) score++;
    if (p.contains(RegExp(r'[^A-Za-z0-9]'))) score++;
    return score;
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeShell()),
        );
      }
    } catch (e) {
      if (mounted) showError(context, AppLocalizations.of(context)!.authError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    final email = _email.text.trim();
    final password = _password.text;
    final auth = ref.read(authProvider.notifier);
    switch (_mode) {
      case _AuthMode.login:
        _run(() => auth.signInWithEmail(email, password));
      case _AuthMode.register:
        _run(() => auth.registerWithEmail(email, password));
      case _AuthMode.forgot:
        _run(() async {
          await auth.sendPasswordReset(email);
          if (mounted) {
            showError(context, l10n.resetLinkSent);
            setState(() => _mode = _AuthMode.login);
          }
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isForgot = _mode == _AuthMode.forgot;
    final isRegister = _mode == _AuthMode.register;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(Icons.terminal,
                          size: 42, color: theme.colorScheme.onPrimary),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      isForgot
                          ? l10n.forgotPassword
                          : isRegister
                              ? l10n.register
                              : l10n.login,
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      decoration: InputDecoration(
                        labelText: l10n.email,
                        prefixIcon: const Icon(Icons.mail_outline),
                      ),
                      validator: (v) =>
                          (v == null || !v.contains('@') || !v.contains('.'))
                              ? l10n.emailInvalid
                              : null,
                    ),
                    if (!isForgot) ...[
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _password,
                        obscureText: _obscure,
                        autofillHints: const [AutofillHints.password],
                        decoration: InputDecoration(
                          labelText: l10n.password,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? l10n.fieldRequired : null,
                        onChanged: (_) => setState(() {}),
                      ),
                      if (isRegister) ...[
                        const SizedBox(height: 8),
                        _StrengthMeter(score: _strength(_password.text), l10n: l10n),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _confirm,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: l10n.confirmPassword,
                            prefixIcon: const Icon(Icons.lock_outline),
                          ),
                          validator: (v) => (v != _password.text)
                              ? l10n.passwordMismatch
                              : (v == null || v.length < AppConstants.minPasswordLength)
                                  ? l10n.passwordShort
                                  : null,
                        ),
                      ],
                    ],
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _busy ? null : _submit,
                      child: _busy
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2))
                          : Text(
                              isForgot
                                  ? l10n.save
                                  : isRegister
                                      ? l10n.register
                                      : l10n.login,
                            ),
                    ),
                    if (!isForgot) ...[
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed:
                            _busy ? null : () => _run(() => ref.read(authProvider.notifier).signInWithGoogle()),
                        icon: const Icon(Icons.g_mobiledata, size: 28),
                        label: Text(l10n.continueWithGoogle),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!isForgot)
                          TextButton(
                            onPressed: () => setState(() => _mode =
                                isRegister ? _AuthMode.login : _AuthMode.register),
                            child: Text(isRegister
                                ? l10n.login
                                : l10n.register),
                          )
                        else
                          const SizedBox.shrink(),
                        TextButton(
                          onPressed: () => setState(() => _mode =
                              isForgot ? _AuthMode.login : _AuthMode.forgot),
                          child: Text(l10n.forgotPassword),
                        ),
                      ],
                    ),
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

class _StrengthMeter extends StatelessWidget {
  final int score;
  final AppLocalizations l10n;
  const _StrengthMeter({required this.score, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (score) {
      <= 1 => theme.colorScheme.error,
      2 => Colors.orange,
      _ => Colors.green,
    };
    final label = switch (score) {
      <= 1 => l10n.passwordWeak,
      2 => l10n.passwordFair,
      _ => l10n.passwordStrong,
    };
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 4,
              color: color,
              backgroundColor:
                  theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(label,
            style: theme.textTheme.bodySmall?.copyWith(color: color)),
      ],
    );
  }
}
