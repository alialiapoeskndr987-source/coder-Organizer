import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/security/flag_secure.dart';
import '../core/security/totp.dart';
import '../data/services/security_service.dart';
import 'core_providers.dart';

// ── v2.0 security controller (D-028..D-031) ─────────────────────────────

/// Why the app is currently locked.
enum LockReason { none, password, totp }

/// Immutable snapshot of the security state consumed by UI + gates.
class SecurityState {
  final bool hasPassword;
  final bool antiTheftEnabled; // TOTP secret stored
  final bool requireOnOpen;
  final bool requireOnActions;
  final int lockTimeoutMinutes; // 1/5/15/30/120 (D-030)
  final int maxAttempts; // failed password attempts before TOTP lock (D-031)
  final LockReason lockReason;
  final int failedAttempts;
  final bool ready; // false until the async bootstrap finishes

  const SecurityState({
    required this.hasPassword,
    required this.antiTheftEnabled,
    required this.requireOnOpen,
    required this.requireOnActions,
    required this.lockTimeoutMinutes,
    required this.maxAttempts,
    this.lockReason = LockReason.none,
    this.failedAttempts = 0,
    this.ready = false,
  });

  bool get isLocked => lockReason != LockReason.none;

  SecurityState copyWith({
    bool? hasPassword,
    bool? antiTheftEnabled,
    bool? requireOnOpen,
    bool? requireOnActions,
    int? lockTimeoutMinutes,
    int? maxAttempts,
    LockReason? lockReason,
    int? failedAttempts,
    bool? ready,
  }) =>
      SecurityState(
        hasPassword: hasPassword ?? this.hasPassword,
        antiTheftEnabled: antiTheftEnabled ?? this.antiTheftEnabled,
        requireOnOpen: requireOnOpen ?? this.requireOnOpen,
        requireOnActions: requireOnActions ?? this.requireOnActions,
        lockTimeoutMinutes: lockTimeoutMinutes ?? this.lockTimeoutMinutes,
        maxAttempts: maxAttempts ?? this.maxAttempts,
        lockReason: lockReason ?? this.lockReason,
        failedAttempts: failedAttempts ?? this.failedAttempts,
        ready: ready ?? this.ready,
      );
}

class SecurityController extends StateNotifier<SecurityState> {
  final SecurityService _service;

  /// When the app went to background — drives idle auto-lock (D-030).
  DateTime? _pausedAt;

  /// Cached TOTP secret for fast verification while unlocked.
  String? _totpSecret;

  SecurityController(this._service)
      : super(const SecurityState(
          hasPassword: false,
          antiTheftEnabled: false,
          requireOnOpen: true,
          requireOnActions: false,
          lockTimeoutMinutes: 5,
          maxAttempts: 3,
        )) {
    bootstrap();
  }

  SecurityService get service => _service;

  Future<void> bootstrap() async {
    final hasPw = await _service.hasPassword();
    final totp = await _service.hasTotp();
    _totpSecret = totp ? await _service.totpSecret() : null;
    final stickyLock = totp && await _service.isTotpLocked();
    final requireOpen = await _service.requireOnOpen();
    final requireActions = await _service.requireOnActions();
    final timeout = await _service.lockTimeoutMinutes();
    final maxAtt = await _service.maxAttempts();
    final failures = await _service.failedCount();

    state = SecurityState(
      hasPassword: hasPw,
      antiTheftEnabled: totp,
      requireOnOpen: requireOpen,
      requireOnActions: requireActions,
      lockTimeoutMinutes: timeout,
      maxAttempts: maxAtt,
      failedAttempts: failures,
      ready: true,
      lockReason: stickyLock
          ? LockReason.totp
          : (hasPw && requireOpen ? LockReason.password : LockReason.none),
    );
    await FlagSecure.set(stickyLock || (hasPw && requireOpen));
  }

  // ── Unlock / lock ────────────────────────────────────────────────────

  /// Password attempt from the lock screen or a sensitive-action gate.
  /// Wrong attempts count toward the anti-theft trigger (D-031).
  Future<bool> verifyPassword(String password) async {
    if (state.lockReason == LockReason.totp) return false; // no bypass
    final ok = await _service.verifyPassword(password);
    if (ok) {
      await _service.resetFailures();
      state = state.copyWith(
          lockReason: LockReason.none, failedAttempts: 0);
      await FlagSecure.set(false);
      return true;
    }
    final failures = await _service.registerFailure();
    if (state.antiTheftEnabled && failures >= state.maxAttempts) {
      await _service.setTotpLocked(true);
      state = state.copyWith(
          lockReason: LockReason.totp, failedAttempts: failures);
      await FlagSecure.set(true);
    } else {
      state = state.copyWith(failedAttempts: failures);
    }
    return false;
  }

  /// TOTP attempt (anti-theft screen). Also clears the sticky lock.
  Future<bool> verifyTotpCode(String code) async {
    final secret = _totpSecret ?? await _service.totpSecret();
    if (secret == null) return false;
    if (!verifyTotp(secret, code)) return false;
    await _service.setTotpLocked(false);
    await _service.resetFailures();
    state = state.copyWith(lockReason: LockReason.none, failedAttempts: 0);
    await FlagSecure.set(false);
    return true;
  }

  /// One-time recovery code attempt (consumes the code).
  Future<bool> verifyRecoveryCode(String code) async {
    final ok = await _service.verifyRecoveryCode(code);
    if (!ok) return false;
    await _service.setTotpLocked(false);
    await _service.resetFailures();
    state = state.copyWith(lockReason: LockReason.none, failedAttempts: 0);
    await FlagSecure.set(false);
    return true;
  }

  void lock() {
    if (!state.hasPassword) return;
    // If anti-theft already tripped, keep the TOTP screen (sticky).
    state = state.copyWith(
        lockReason:
            state.lockReason == LockReason.totp ? LockReason.totp : LockReason.password);
    FlagSecure.set(true);
  }

  // ── Lifecycle (D-030 idle auto-lock) ────────────────────────────────
  void onPaused() => _pausedAt = DateTime.now();

  void onResumed() {
    final paused = _pausedAt;
    _pausedAt = null;
    if (paused == null || !state.hasPassword || state.isLocked) return;
    final idle = DateTime.now().difference(paused);
    if (idle >= Duration(minutes: state.lockTimeoutMinutes)) {
      lock();
    }
  }

  // ── Settings mutations ──────────────────────────────────────────────
  Future<void> setAppPassword(String password) async {
    await _service.setPassword(password);
    state = state.copyWith(hasPassword: true);
  }

  Future<void> changeAppPassword(String current, String next) async {
    final ok = await _service.verifyPassword(current);
    if (!ok) throw SecurityException('wrong current password');
    await _service.setPassword(next);
  }

  /// Removes the password and EVERYTHING built on it (anti-theft + codes).
  Future<void> removeAppPassword() async {
    await _service.clearPassword();
    await _service.clearTotp();
    await _service.resetFailures();
    _totpSecret = null;
    state = state.copyWith(
      hasPassword: false,
      antiTheftEnabled: false,
      lockReason: LockReason.none,
      failedAttempts: 0,
    );
    await FlagSecure.set(false);
  }

  Future<void> setRequireOnOpen(bool v) async {
    await _service.setRequireOnOpen(v);
    state = state.copyWith(requireOnOpen: v);
  }

  Future<void> setRequireOnActions(bool v) async {
    await _service.setRequireOnActions(v);
    state = state.copyWith(requireOnActions: v);
  }

  Future<void> setLockTimeoutMinutes(int minutes) async {
    await _service.setLockTimeoutMinutes(minutes);
    state = state.copyWith(lockTimeoutMinutes: minutes);
  }

  Future<void> setMaxAttempts(int n) async {
    await _service.setMaxAttempts(n);
    state = state.copyWith(maxAttempts: n);
  }

  /// Wizard step: persist the verified secret + issue recovery codes.
  Future<List<String>> enableAntiTheft(String verifiedSecret) async {
    await _service.storeTotpSecret(verifiedSecret);
    _totpSecret = verifiedSecret;
    final codes = await _service.generateRecoveryCodes();
    state = state.copyWith(antiTheftEnabled: true);
    return codes;
  }

  Future<void> disableAntiTheft() async {
    await _service.clearTotp();
    _totpSecret = null;
    await _service.resetFailures();
    state = state.copyWith(
        antiTheftEnabled: false, lockReason: LockReason.none, failedAttempts: 0);
  }
}

class SecurityException implements Exception {
  final String message;
  const SecurityException(this.message);
}

final securityServiceProvider = Provider<SecurityService>(
    (ref) => SecurityService(ref.watch(appDatabaseProvider)));

final securityProvider =
    StateNotifierProvider<SecurityController, SecurityState>((ref) {
  return SecurityController(ref.watch(securityServiceProvider));
});

/// Sensitive-action gate (D-028): when enabled in settings, password is
/// re-asked before export/import/purge/security changes.
bool needsSensitiveAuth(SecurityState s) =>
    s.hasPassword && s.requireOnActions && !s.isLocked;
