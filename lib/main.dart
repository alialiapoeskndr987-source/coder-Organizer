import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/theme/app_theme.dart';
import 'data/db/app_database.dart';
import 'providers/core_providers.dart';
import 'providers/profile_providers.dart';
import 'providers/settings_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FR-01 — Firebase is used when configured (google-services.json present);
  // otherwise the app boots in local mode (D-019 current environment).
  bool firebaseReady = false;
  try {
    await Firebase.initializeApp();
    firebaseReady = true;
  } catch (_) {
    firebaseReady = false;
  }

  // Open the database first so user preferences can seed the very first frame.
  final db = AppDatabase();

  // NFR-06 — preload the saved language and theme BEFORE runApp: MaterialApp
  // must never start on the system locale when the user already picked one
  // (no wrong-language flash on an Arabic device set to English). With no
  // saved choice, LocaleController stays null and the app intentionally
  // follows the device language (standard behavior).
  final savedLocale = await db.getSetting('locale');
  final savedThemeIdx = int.tryParse(await db.getSetting('theme') ?? '') ?? 0;
  final initialTheme =
      AppTheme.values[savedThemeIdx.clamp(0, AppTheme.values.length - 1)];
  final initialLocale =
      (savedLocale == null || savedLocale.isEmpty) ? null : Locale(savedLocale);

  // v2.0 (D-021) — resolve the active profile before the first frame and
  // give the seeded default profile a localized name exactly once.
  final profiles = await db.watchProfiles().first;
  final savedProfileId =
      int.tryParse(await db.getSetting('current_profile_id') ?? '') ?? 1;
  final activeProfile = profiles.any((p) => p.id == savedProfileId)
      ? savedProfileId
      : (profiles.isNotEmpty ? profiles.first.id : 1);
  final isAr = (initialLocale?.languageCode ?? 'ar') == 'ar';
  await db.renameDefaultProfileIfNeeded(isAr ? 'افتراضي' : 'Default');

  final container = ProviderContainer(
    overrides: [
      firebaseReadyProvider.overrideWithValue(firebaseReady),
      appDatabaseProvider.overrideWithValue(db),
      themeProvider
          .overrideWith((ref) => ThemeController(db, initialTheme)),
      localeProvider
          .overrideWith((ref) => LocaleController(db, initialLocale)),
      currentProfileIdProvider.overrideWith(
          (ref) => CurrentProfileController(db, activeProfile)),
    ],
  );

  // Bootstrap: analytics consent (D-017) + notifications channel (FR-06).
  final consent = await db.getSetting('analytics_consent');
  container.read(analyticsConsentProvider.notifier).state = consent == '1';

  final notifications = container.read(notificationsProvider);
  await notifications.init();
  await notifications.requestPermission();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const CoderOrganizerApp(),
    ),
  );
}
