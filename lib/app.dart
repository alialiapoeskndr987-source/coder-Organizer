import 'package:flutter/material.dart';
import 'package:coder_organizer/l10n/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/services/notification_service.dart';
import 'features/node/node_details_screen.dart';
import 'features/splash/splash_screen.dart';
import 'core/theme/app_theme.dart';
import 'providers/settings_providers.dart';

/// coder-organizer v1.22 (D-020) — MaterialApp wiring: themes (D-008),
/// locales en/ar (D-012), RTL support (NFR-05), notification deep-link.
class CoderOrganizerApp extends ConsumerStatefulWidget {
  const CoderOrganizerApp({super.key});

  @override
  ConsumerState<CoderOrganizerApp> createState() =>
      _CoderOrganizerAppState();
}

class _CoderOrganizerAppState extends ConsumerState<CoderOrganizerApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Tapping a system notification while the app is closed/ background:
    // open the related node details.
    NotificationService.onNotificationTap = (nodeId) {
      _navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => NodeDetailsScreen(nodeId: nodeId)),
      );
    };
  }

  @override
  void dispose() {
    NotificationService.onNotificationTap = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      title: 'Coder Organizer',
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: theme.material(),
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      home: const SplashScreen(),
    );
  }
}
