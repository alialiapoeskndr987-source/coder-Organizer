import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/theme/app_theme.dart';
import 'data/db/app_database.dart';
import 'providers/core_providers.dart';
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

  final container = ProviderContainer(
    overrides: [
      firebaseReadyProvider.overrideWithValue(firebaseReady),
      appDatabaseProvider.overrideWithValue(db),
      themeProvider
          .overrideWith((ref) => ThemeController(db, initialTheme)),
      localeProvider
          .overrideWith((ref) => LocaleController(db, initialLocale)),
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
