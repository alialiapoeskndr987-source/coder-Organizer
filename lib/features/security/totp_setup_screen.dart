import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';

import '../../core/security/totp.dart';
import '../../providers/profile_providers.dart';
import '../../providers/security_providers.dart';

/// v2.0 (D-029) — anti-theft enrollment wizard (option A, fully offline):
///
///  1. Scan the QR (or copy the secret) into any authenticator app
///     (Google Authenticator, Aegis, Authy…).
///  2. Confirm by entering the current 6-digit code.
///  3. Show the 10 one-time recovery codes once — user confirms saving.
///
/// No bot, no network, no server: the code is computed locally by the
/// authenticator and verified locally by the app.
class TotpSetupScreen extends ConsumerStatefulWidget {
  const TotpSetupScreen({super.key});

  @override
  ConsumerState<TotpSetupScreen> createState() => _TotpSetupScreenState();
}

enum _Step { scan, confirm, codes }

class _TotpSetupScreenState extends ConsumerState<TotpSetupScreen> {
  late String _secret = generateTotpSecret();
  _Step _step = _Step.scan;
  List<String>? _codes;
  bool _busy = false;
  String? _error;

  String get _otpauthUri {
    final profileId = ref.read(currentProfileIdProvider);
    final profiles = ref.read(profilesProvider).value ?? const [];
    final name = profiles.where((p) => p.id == profileId).firstOrNull?.name ??
        'Coder Organizer';
    final encoded = Uri.encodeComponent('Coder Organizer: $name');
    return 'otpauth://totp/$encoded'
        '?secret=$_secret&issuer=Coder%20Organizer&digits=6&period=30';
  }

  Future<void> _confirm() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok =
        ref.read(securityServiceProvider).verifyNewSecret(_secret, _code.text.trim());
    if (!mounted) return;
    if (!ok) {
      setState(() {
        _busy = false;
        _error = l10n.wrongCode;
      });
      return;
    }
    final codes =
        await ref.read(securityProvider.notifier).enableAntiTheft(_secret);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _codes = codes;
      _step = _Step.codes;
    });
  }

  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.totpSetupTitle)),
      body: switch (_step) {
        _Step.scan => _buildScan(theme, l10n),
        _Step.confirm => _buildConfirm(theme, l10n),
        _Step.codes => _buildCodes(theme, l10n),
      },
    );
  }

  Widget _buildScan(ThemeData theme, AppLocalizations l10n) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l10n.totpStep1,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: QrImageView(
                data: _otpauthUri,
                size: 220,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(l10n.secretKey,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Card(
            child: ListTile(
              title: Text(_secret,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontFamily: 'monospace')),
              trailing: IconButton(
                icon: const Icon(Icons.copy_rounded),
                tooltip: l10n.copy,
                onPressed: () async {
                  // Copy without extra deps.
                  await _copy(context, _secret);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => setState(() => _step = _Step.confirm),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(l10n.next),
          ),
        ],
      );

  Widget _buildConfirm(ThemeData theme, AppLocalizations l10n) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.totpStep2,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 18),
            TextField(
              controller: _code,
              autofocus: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
              decoration: InputDecoration(
                labelText: l10n.enterTotp,
                counterText: '',
                errorText: _error,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _busy ? null : _confirm,
              icon: const Icon(Icons.verified_user_outlined),
              label: Text(l10n.confirm),
            ),
          ],
        ),
      );

  Widget _buildCodes(ThemeData theme, AppLocalizations l10n) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(children: [
            Icon(Icons.check_circle, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
                child: Text(l10n.totpEnabledDone,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700))),
          ]),
          const SizedBox(height: 14),
          Text(l10n.recoveryCodesDesc,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final c in _codes ?? const <String>[])
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text(c,
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(fontFamily: 'monospace')),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () =>
                _copy(context, (_codes ?? const []).join('\n')),
            icon: const Icon(Icons.copy_all_rounded),
            label: Text(l10n.copyCodes),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.task_alt_rounded),
            label: Text(l10n.savedCodesConfirm),
          ),
        ],
      );

  Future<void> _copy(BuildContext context, String text) async {
    final messenger = ScaffoldMessenger.of(context);
    // Clipboard from services — imported via material.
    await Clipboard.setData(ClipboardData(text: text));
    messenger.showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.copied)));
  }
}
