import 'package:firebase_analytics/firebase_analytics.dart';

/// Firebase Analytics with consent gate (D-017). Only the five approved
/// events are ever sent; user content never leaves the device (NFR-03).
class AnalyticsService {
  final bool consentGranted;
  final bool firebaseReady;
  FirebaseAnalytics? _analytics;

  AnalyticsService({required this.consentGranted, required this.firebaseReady});

  static const approvedEvents = {
    'install',
    'first_project_created',
    'trial_started',
    'purchase_completed',
    'active_projects_count',
  };

  FirebaseAnalytics? get _instance {
    if (!firebaseReady || !consentGranted) return null;
    return _analytics ??= FirebaseAnalytics.instance;
  }

  Future<void> log(String name, [Map<String, Object>? params]) async {
    if (!approvedEvents.contains(name)) return; // hard gate — approved list only
    final a = _instance;
    if (a == null) return;
    await a.logEvent(name: name, parameters: params);
  }
}
