import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../db/app_database.dart';

/// System notifications that fire while the app is closed (FR-06, SRS 7).
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      const InitializationSettings(android: androidInit),
      onDidReceiveNotificationResponse: _onTap,
    );
    _ready = true;
  }

  /// Android 13+ runtime permission (POST_NOTIFICATIONS).
  Future<bool> requestPermission() async {
    await init();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestNotificationsPermission() ?? false;
  }

  /// Schedules [alert] (and its early reminder). Replaces any previous
  /// schedule for the same alert id. Falls back to inexact alarms when the
  /// exact-alarm permission is unavailable on Android 14+.
  Future<void> scheduleAlert(Alert alert, {String? body}) async {
    await init();
    await cancelAlert(alert.id);
    if (!alert.enabled) return;
    final now = DateTime.now();
    if (alert.fireAt.isBefore(now)) return;
    var when = alert.fireAt;
    if (alert.reminderMinutesBefore > 0) {
      final early = alert.fireAt
          .subtract(Duration(minutes: alert.reminderMinutesBefore));
      if (early.isAfter(now)) when = early;
    }
    final at = tz.TZDateTime.from(when, tz.local);
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'coder_organizer_alerts',
        'Project alerts',
        channelDescription: 'Alerts scheduled on nodes',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    try {
      await _plugin.zonedSchedule(
        alert.id,
        alert.title,
        body,
        at,
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (_) {
      await _plugin.zonedSchedule(
        alert.id,
        alert.title,
        body,
        at,
        details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelAlert(int id) async {
    if (!_ready) return;
    await _plugin.cancel(id);
  }

  /// Reschedules everything (after import, restore, or app start).
  Future<void> rescheduleAll(List<Alert> alerts) async {
    for (final a in alerts) {
      await scheduleAlert(a);
    }
  }

  /// Tap payload format: `node:<id>` — handled in app.dart navigation.
  static String payloadFor(int nodeId) => 'node:$nodeId';

  static int? nodeIdFromPayload(String? payload) {
    if (payload == null || !payload.startsWith('node:')) return null;
    return int.tryParse(payload.substring(5));
  }

  static void Function(int nodeId)? onNotificationTap;

  void _onTap(NotificationResponse r) {
    final id = nodeIdFromPayload(r.payload);
    if (id != null) onNotificationTap?.call(id);
  }
}
