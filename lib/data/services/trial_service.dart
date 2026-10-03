import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/constants/app_constants.dart';
import '../db/app_database.dart';

/// Trial + entitlement state (D-014, D-015, D-018).
///
/// The trial start is stored twice — Drift settings and secure storage — and
/// the *earliest* value wins, so clearing app data or shifting the clock
/// cannot extend the trial beyond the 30-day window.
class TrialService {
  static const _startKey = 'trial_start';
  static const _purchasedKey = 'purchased';

  final AppDatabase _db;
  final FlutterSecureStorage _secure;

  TrialService(this._db, {FlutterSecureStorage? secure})
      : _secure = secure ?? const FlutterSecureStorage();

  Future<DateTime?> _secureStart() async {
    final v = await _secure.read(key: _startKey);
    return v == null ? null : DateTime.tryParse(v);
  }

  /// Ensures a trial start exists; returns the effective (earliest) start.
  Future<DateTime> ensureTrialStart() async {
    final dbVal = await _db.getSetting(_startKey);
    final dbStart = dbVal == null ? null : DateTime.tryParse(dbVal);
    final secStart = await _secureStart();

    DateTime? earliest;
    for (final c in [dbStart, secStart]) {
      if (c != null && (earliest == null || c.isBefore(earliest))) {
        earliest = c;
      }
    }
    final start = earliest ?? DateTime.now();

    final dbStart2 = await _db.getSetting(_startKey);
    if (dbStart2 == null ||
        (DateTime.tryParse(dbStart2)?.isAfter(start) ?? true)) {
      await _db.setSetting(_startKey, start.toIso8601String());
    }
    final secVal = await _secure.read(key: _startKey);
    if (secVal == null || (DateTime.tryParse(secVal)?.isAfter(start) ?? true)) {
      await _secure.write(key: _startKey, value: start.toIso8601String());
    }
    return start;
  }

  /// Days left in the 30-day full-featured trial (D-015, pattern A).
  Future<int> daysRemaining() async {
    final start = await ensureTrialStart();
    final elapsed = DateTime.now().difference(start).inDays;
    return (AppConstants.trialDays - elapsed)
        .clamp(0, AppConstants.trialDays);
  }

  Future<bool> isPurchased() async {
    final dbVal = await _db.getSetting(_purchasedKey);
    return dbVal == '1' || await _secure.read(key: _purchasedKey) == '1';
  }

  Future<void> setPurchased(bool v) async {
    await _db.setSetting(_purchasedKey, v ? '1' : '0');
    await _secure.write(key: _purchasedKey, value: v ? '1' : '0');
  }

  /// Editing/creating is blocked when the trial expired and no purchase (SRS 5).
  Future<bool> canEdit() async =>
      await daysRemaining() > 0 || await isPurchased();
}
