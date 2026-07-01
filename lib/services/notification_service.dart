import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Required top-level handler for background FCM messages
@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {}

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'brain_twist_daily';
  static const _channelName = 'Daily Reminder';
  static const _notifId = 0;

  static Future<void> initialize() async {
    // ── Local notifications ──────────────────────────
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(requestAlertPermission: false);
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    // ── FCM ─────────────────────────────────────────
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
    await FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onMessage.listen(_showForegroundNotif);

    // Schedule daily local reminder (fires every 24 h from first launch)
    await _scheduleDailyReminder();
  }

  static Future<void> _scheduleDailyReminder() async {
    // ── FIX: cancelAll() first to clear any stale/incompatible ──
    // scheduled notification data from previous plugin versions.
    // Without this, pendingNotificationRequests() throws
    // "Missing type parameter" on devices that had the old format.
    try {
      await _plugin.cancelAll();
    } catch (e) {
      debugPrint('cancelAll (non-fatal): $e');
    }

    // Now safe to schedule fresh
    try {
      await _plugin.periodicallyShow(
        _notifId,
        'Brain Twist 🧠',
        'Your daily puzzle is waiting! Come back and play.',
        RepeatInterval.daily,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexact,
      );
      debugPrint('✅ Daily reminder scheduled');
    } catch (e) {
      debugPrint('Schedule reminder failed (non-fatal): $e');
    }
  }

  static void _showForegroundNotif(RemoteMessage message) {
    final n = message.notification;
    if (n == null) return;
    _plugin.show(
      n.hashCode,
      n.title,
      n.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  static Future<String?> getFcmToken() => FirebaseMessaging.instance.getToken();

  // Call this from a debug button to instantly fire a local notification
  static Future<void> testLocalNotification() async {
    await _plugin.show(
      99,
      'Brain Twist 🧠 (Test)',
      'Your daily puzzle is waiting! Come back and play.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}
