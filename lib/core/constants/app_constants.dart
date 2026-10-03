/// Central code constants — decision D-020 (owner-approved identity).
/// Renaming/rebranding later requires editing this file only.
class AppConstants {
  AppConstants._();

  // ── Identity (D-020) ─────────────────────────────────────────────
  static const String appName = 'coder-organizer';
  static const String appDisplayName = 'Coder Organizer';
  static const String appVersion = '1.22';
  static const String applicationId = 'com.coderorganizer';

  // ── Monetization (D-014, D-018) ──────────────────────────────────
  static const String iapProductId = 'coder_organizer_lifetime';
  static const int trialDays = 30;

  // ── Local data rules ─────────────────────────────────────────────
  static const int maxNotesPerNode = 50; // D-007
  static const int trashRetentionDays = 30; // D-010
  static const int mainTitleMaxLength = 60; // FR-02
  static const int minPasswordLength = 8; // FR-01

  // ── Export / import (FR-02) ──────────────────────────────────────
  static const String exportFilePrefix = 'coder-organizer-backup';
  static const int exportSchemaVersion = 1;
}
