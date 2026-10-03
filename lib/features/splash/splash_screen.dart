import 'dart:async';

import 'package:flutter/material.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../providers/core_providers.dart';
import '../auth/auth_screen.dart';
import '../home/home_shell.dart';

/// Splash → bootstrap (trial start, trash purge, alert rescheduling) → gate.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    final db = ref.read(appDatabaseProvider);
    final trial = ref.read(trialServiceProvider);

    // Trial start on first launch (D-015) — full features for 30 days.
    await trial.ensureTrialStart();
    // NFR-04/D-010 — purge trash past retention, prune open logs.
    await db.nodesDao.purgeOldTrash(AppConstants.trashRetentionDays);
    await db.pruneOpenLogs();
    // FR-06 — keep system notifications in sync with stored alerts.
    final alerts = await db.elementsDao.allEnabledAlerts();
    await ref.read(notificationsProvider).rescheduleAll(alerts);

    unawaited(ref.read(analyticsProvider).log('install'));
    unawaited(ref.read(trialProvider.notifier).refresh());
    unawaited(ref.read(billingProvider.notifier).init());

    if (!mounted) return;
    final auth = ref.read(authServiceProvider);
    final loggedIn =
        auth.isFirebaseBacked ? ref.read(authProvider) != null : true;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => loggedIn ? const HomeShell() : const AuthScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.terminal,
                size: 52,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppConstants.appDisplayName,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.tagline,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 28),
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ],
        ),
      ),
    );
  }
}
