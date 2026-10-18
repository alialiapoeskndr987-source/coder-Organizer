import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/constants/app_constants.dart';
import '../../core/security/pbkdf2.dart';
import '../../core/security/totp.dart';
import '../db/app_database.dart';

/// v2.0 — all security material lives in flutter_secure_storage
/// (Android Keystore-backed), never in the SQLite database:
///
///  - app password: PBKDF2-SHA256 salt + hash + iteration count (D-028)
///  - TOTP secret for the authenticator-based anti-theft (D-029)
///  - SHA-256 hashes of the 10 one-time recovery codes (D-029)
///  - failed-attempt counter + the sticky "totp locked" flag (D-031)
///
/// Non-sensitive *behavior* switches (require-on-open, auto-lock timeout,
/// max attempts) are plain app settings so they survive restore and are
/// easy to back up — they never unlock anything by themselves.
class SecurityService {
  static const _pwSalt = 'sec.pw.salt';
  static const _pwHash = 'sec.pw.hash';
  static const _pwIter = 'sec.pw.iter';
  static const _totpSecret = 'sec.totp.secret';
  static const _recoveryHashes = 'sec.recovery.hashes';
  static const _failed = 'sec.failed.count';
  static const _totpLocked = 'sec.totp.locked';

  final AppDatabase _db;
  final FlutterSecureStorage _secure;

  SecurityService(this._db, {FlutterSecureStorage? secure})
      : _secure = secure ?? const FlutterSecureStorage();

  // ── App password (D-028) ────────────────────────────────────────────
  Future<bool> hasPassword() async {
    final h = await _secure.read(key: _pwHash);
    return h != null && h.isNotEmpty;
  }

  Future<void> setPassword(String password) async {
    final salt = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    final hash = pbkdf2HmacSha256(
      password,
      salt,
      AppConstants.pbkdf2Iterations,
      AppConstants.pbkdf2KeyLength,
    );
    await _secure.write(key: _pwSalt, value: base64Encode(salt));
    await _secure.write(
        key: _pwHash, value: base64Encode(hash));
    await _secure.write(
        key: _pwIter, value: '${AppConstants.pbkdf2Iterations}');
  }

  Future<bool> verifyPassword(String password) async {
    final saltB64 = await _secure.read(key: _pwSalt);
    final hashB64 = await _secure.read(key: _pwHash);
    if (saltB64 == null || hashB64 == null) return false;
    final iter =
        int.tryParse(await _secure.read(key: _pwIter) ?? '') ??
            AppConstants.pbkdf2Iterations;
    final computed = pbkdf2HmacSha256(
      password,
      base64Decode(saltB64),
      iter,
      AppConstants.pbkdf2KeyLength,
    );
    return base64Encode(computed) == hashB64;
  }

  Future<void> clearPassword() async {
    await _secure.delete(key: _pwSalt);
    await _secure.delete(key: _pwHash);
    await _secure.delete(key: _pwIter);
  }

  // ── Failed attempts + sticky anti-theft lock (D-031) ────────────────
  Future<int> failedCount() async =>
      int.tryParse(await _secure.read(key: _failed) ?? '') ?? 0;

  /// Records a wrong attempt; returns the new count.
  Future<int> registerFailure() async {
    final n = await failedCount() + 1;
    await _secure.write(key: _failed, value: '$n');
    return n;
  }

  Future<void> resetFailures() async => _secure.delete(key: _failed);

  /// Sticky flag: once triggered, the anti-theft screen survives restarts
  /// so closing the app cannot bypass the TOTP requirement.
  Future<bool> isTotpLocked() async =>
      (await _secure.read(key: _totpLocked)) == '1';

  Future<void> setTotpLocked(bool locked) async {
    if (locked) {
      await _secure.write(key: _totpLocked, value: '1');
    } else {
      await _secure.delete(key: _totpLocked);
    }
  }

  // ── TOTP (D-029) ────────────────────────────────────────────────────
  Future<bool> hasTotp() async {
    final s = await _secure.read(key: _totpSecret);
    return s != null && s.isNotEmpty;
  }

  Future<void> storeTotpSecret(String b32) =>
      _secure.write(key: _totpSecret, value: b32.toUpperCase());

  Future<String?> totpSecret() => _secure.read(key: _totpSecret);

  Future<void> clearTotp() async {
    await _secure.delete(key: _totpSecret);
    await _secure.delete(key: _recoveryHashes);
    await _secure.delete(key: _totpLocked);
  }

  /// Verifies a candidate secret during the wizard (before persisting).
  bool verifyNewSecret(String secretB32, String code) =>
      verifyTotp(secretB32, code);

  // ── Recovery codes (D-029) ──────────────────────────────────────────
  /// Generates 10 one-time codes, stores only their SHA-256 hashes and
  /// returns the plaintext ONCE (caller must show/copy them immediately).
  Future<List<String>> generateRecoveryCodes() async {
    final rnd = Random.secure();
    final codes = List.generate(AppConstants.recoveryCodeCount, (_) {
      final bytes = List<int>.generate(4, (_) => rnd.nextInt(256));
      return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    });
    final hashes = codes.map((c) => sha256.convert(utf8.encode(c)).toString());
    await _secure.write(key: _recoveryHashes, value: hashes.join(','));
    return codes;
  }

  Future<bool> hasRecoveryCodes() async {
    final v = await _secure.read(key: _recoveryHashes);
    return v != null && v.isNotEmpty;
  }

  /// Checks a recovery code and consumes it (each code works once).
  Future<bool> verifyRecoveryCode(String code) async {
    final v = await _secure.read(key: _recoveryHashes);
    if (v == null || v.isEmpty) return false;
    final hashes = v.split(',').toList();
    final h = sha256.convert(utf8.encode(code.trim())).toString();
    if (!hashes.contains(h)) return false;
    hashes.remove(h);
    await _secure.write(key: _recoveryHashes, value: hashes.join(','));
    return true;
  }

  // ── Behavior settings (plain KV, non-sensitive) ─────────────────────
  Future<bool> requireOnOpen() async =>
      (await _db.getSetting('sec_require_on_open')) != '0';

  Future<void> setRequireOnOpen(bool v) =>
      _db.setSetting('sec_require_on_open', v ? '1' : '0');

  Future<bool> requireOnActions() async =>
      (await _db.getSetting('sec_require_on_actions')) == '1';

  Future<void> setRequireOnActions(bool v) =>
      _db.setSetting('sec_require_on_actions', v ? '1' : '0');

  /// Idle auto-lock in minutes (1/5/15/30/120 — D-030).
  Future<int> lockTimeoutMinutes() async =>
      int.tryParse(await _db.getSetting('sec_lock_timeout') ?? '') ??
          AppConstants.defaultLockTimeoutMinutes;

  Future<void> setLockTimeoutMinutes(int minutes) =>
      _db.setSetting('sec_lock_timeout', '$minutes');

  Future<int> maxAttempts() async =>
      int.tryParse(await _db.getSetting('sec_max_attempts') ?? '') ??
          AppConstants.defaultMaxAttempts;

  Future<void> setMaxAttempts(int n) =>
      _db.setSetting('sec_max_attempts', '$n');
}
