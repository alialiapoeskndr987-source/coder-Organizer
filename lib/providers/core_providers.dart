import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/enums.dart';
import '../data/db/app_database.dart';
import '../data/services/analytics_service.dart';
import '../data/services/auth_service.dart';
import '../data/services/billing_service.dart';
import '../data/services/import_export_service.dart';
import '../data/services/notification_service.dart';
import '../data/services/trial_service.dart';

// ── Core singletons ───────────────────────────────────────────────────
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Overridden in main() after the Firebase init attempt.
final firebaseReadyProvider = Provider<bool>((ref) => false);

final authServiceProvider = Provider<AuthService>((ref) => ref
    .watch(firebaseReadyProvider)
    ? FirebaseAuthService()
    : LocalAuthService());

final trialServiceProvider =
    Provider<TrialService>((ref) => TrialService(ref.watch(appDatabaseProvider)));

final notificationsProvider =
    Provider<NotificationService>((ref) => NotificationService());

final importExportProvider = Provider<ImportExportService>(
    (ref) => ImportExportService(ref.watch(appDatabaseProvider)));

/// Loaded from settings during bootstrap; toggled in Settings (D-017).
final analyticsConsentProvider = StateProvider<bool>((ref) => false);

final analyticsProvider = Provider<AnalyticsService>((ref) => AnalyticsService(
      consentGranted: ref.watch(analyticsConsentProvider),
      firebaseReady: ref.watch(firebaseReadyProvider),
    ));

// ── Auth (FR-01) ──────────────────────────────────────────────────────
class AuthController extends StateNotifier<AuthUser?> {
  final AuthService _auth;
  AuthController(this._auth) : super(_auth.currentUser) {
    if (_auth.isFirebaseBacked) {
      _auth.authState.listen((u) => state = u);
    }
  }

  bool get isFirebaseBacked => _auth.isFirebaseBacked;

  Future<void> signInWithEmail(String email, String password) =>
      _auth.signInWithEmail(email, password);

  Future<void> registerWithEmail(String email, String password) =>
      _auth.registerWithEmail(email, password);

  Future<void> signInWithGoogle() => _auth.signInWithGoogle();

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordReset(email);

  Future<void> changePassword(String current, String next) =>
      _auth.changePassword(current, next);

  Future<void> signOut() => _auth.signOut();

  Future<void> deleteAccount() => _auth.deleteAccount();
}

final authProvider =
    StateNotifierProvider<AuthController, AuthUser?>((ref) {
  final controller = AuthController(ref.watch(authServiceProvider));
  ref.onDispose(() {});
  return controller;
});

// ── Trial (D-015) & Billing (D-014/D-018) ─────────────────────────────
class TrialData {
  final int daysLeft;
  final bool canEdit;
  final bool purchased;
  const TrialData({
    required this.daysLeft,
    required this.canEdit,
    required this.purchased,
  });
}

class TrialController extends StateNotifier<AsyncValue<TrialData>> {
  final TrialService _trial;
  TrialController(this._trial) : super(const AsyncLoading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      state = AsyncData(TrialData(
        daysLeft: await _trial.daysRemaining(),
        canEdit: await _trial.canEdit(),
        purchased: await _trial.isPurchased(),
      ));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() => _load();
}

final trialProvider =
    StateNotifierProvider<TrialController, AsyncValue<TrialData>>((ref) {
  final c = TrialController(ref.watch(trialServiceProvider));
  ref.onDispose(() {});
  return c;
});

class BillingController extends StateNotifier<PurchaseState> {
  final TrialService _trial;
  final Ref _ref;
  BillingService? _service;

  BillingController(this._trial, this._ref) : super(PurchaseState.unknown);

  String? get price => _service?.currentPrice;

  Future<void> init() async {
    if (await _trial.isPurchased()) state = PurchaseState.purchased;
    final service = BillingService(_trial, onStateChange: (s, _) {
      state = s;
      if (s == PurchaseState.purchased) {
        _ref.read(analyticsProvider).log('purchase_completed');
      }
    });
    _service = service;
    await service.init();
  }

  Future<void> buy() async => _service?.buy();

  Future<void> restore() async => _service?.restore();
}

final billingProvider =
    StateNotifierProvider<BillingController, PurchaseState>((ref) {
  final c = BillingController(ref.watch(trialServiceProvider), ref);
  ref.onDispose(c.dispose);
  return c;
});

// ── Misc actions ──────────────────────────────────────────────────────
final purgeOpenLogs = FutureProvider<void>((ref) async {
  await ref.watch(appDatabaseProvider).pruneOpenLogs();
});
