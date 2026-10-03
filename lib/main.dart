import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'providers/core_providers.dart';

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

  final container = ProviderContainer(
    overrides: [firebaseReadyProvider.overrideWithValue(firebaseReady)],
  );

  // Bootstrap: analytics consent (D-017) + notifications channel (FR-06).
  final db = container.read(appDatabaseProvider);
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
