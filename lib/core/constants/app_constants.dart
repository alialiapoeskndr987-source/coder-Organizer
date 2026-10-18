/// Central code constants — decision D-020 (owner-approved identity).
/// Renaming/rebranding later requires editing this file only.
class AppConstants {
  AppConstants._();

  // ── Identity (D-020) ─────────────────────────────────────────────
  static const String appName = 'coder-organizer';
  static const String appDisplayName = 'Coder Organizer';
  static const String appVersion = '2.0';
  static const String applicationId = 'com.coderorganizer';

  // ── Monetization (D-014, D-018, D-026) ───────────────────────────
  static const String iapProductId = 'coder_organizer_lifetime';
  static const int trialDays = 30;
  static const int maxProfilesFree = 1; // D-026
  static const int maxProfilesPro = 10; // D-026
  static const int maxProjectsFree = 10; // D-026

  // ── Local data rules ─────────────────────────────────────────────
  static const int maxNotesPerNode = 50; // D-007
  static const int trashRetentionDays = 30; // D-010
  static const int mainTitleMaxLength = 60; // FR-02
  static const int minPasswordLength = 8; // FR-01

  // ── Security v2.0 (D-028..D-031) ─────────────────────────────────
  static const int pbkdf2Iterations = 40000; // D-028 (PBKDF2-HMAC-SHA256)
  static const int pbkdf2KeyLength = 32;
  static const int totpDigits = 6; // D-029 (RFC 6238)
  static const int totpPeriodSeconds = 30;
  static const int totpWindow = 1; // accept ±1 period (clock drift)
  static const int recoveryCodeCount = 10; // D-029
  static const int defaultLockTimeoutMinutes = 5; // D-030
  static const int defaultMaxAttempts = 3; // D-031
  static const int undoDepth = 10; // D-025

  // ── Export / import (FR-02) ──────────────────────────────────────
  static const String exportFilePrefix = 'coder-organizer-backup';
  static const int exportSchemaVersion = 2;
}
