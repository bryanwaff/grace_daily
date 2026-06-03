import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:grace_daily/config/app_router.dart';

/// Service to handle local notifications scheduling for daily reminders.
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize local notifications plugin and timezone data
  static Future<void> initNotifications() async {
    if (kIsWeb) return;

    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // Handle when notification is tapped (routes to home/devotion screen)
        if (details.actionId == 'action_read' || details.payload == 'read_payload') {
          AppRouter.router.go('/home/reflection');
        }
      },
    );
  }

  /// Request permissions for local notifications (iOS and Android 13+)
  static Future<void> requestPermissions() async {
    if (kIsWeb) return;

    // Request for Android 13+
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }

    // Request for iOS
    final iosImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (iosImplementation != null) {
      await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  /// Schedule a daily devotion reminder notification at the user's preferred time
  static Future<void> scheduleDailyReminder({required int hour, required int minute}) async {
    if (kIsWeb) return;

    await cancelNotifications();

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If scheduled time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel',
      'Daily Reminders',
      channelDescription: 'Channel for Grace Daily reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'action_read',
          '📖 Read Today',
          showsUserInterface: true,
        ),
      ],
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'daily_reminder_category',
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      0,
      '📖 Morning Devotion Reminder',
      'Take a few moments for grace. Read today\'s verse.',
      scheduledDate,
      notificationDetails,
      payload: 'read_payload',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Show an instant notification celebrating a streak milestone
  static Future<void> showMilestoneNotification({required int streakCount}) async {
    if (kIsWeb) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'milestone_channel',
      'Streak Milestones',
      channelDescription: 'Channel for celebrating devotion streak milestones',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    String title = '';
    String body = '';

    if (streakCount == 3) {
      title = '🎉 3-Day Streak! Off to a great start!';
      body = 'You have completed 3 days of daily devotions. Keep up the beautiful habit!';
    } else if (streakCount == 7) {
      title = '🏆 1-Week Milestone Reached!';
      body = 'A full week of grace and reflection. God is working in your quiet moments!';
    } else if (streakCount == 14) {
      title = '✨ 2-Week Streak! Incredible commitment!';
      body = '14 days of staying faithful in daily devotion. Be proud of your journey!';
    } else if (streakCount == 30) {
      title = '🌅 1-Month Milestone! Truly inspiring!';
      body = '30 days of daily grace. Your consistency is building a beautiful spiritual foundation!';
    } else if (streakCount == 60) {
      title = '🔥 60 Days of Grace!';
      body = 'Two months of unwavering faithfulness. You are deeply rooted!';
    } else if (streakCount == 100) {
      title = '👑 100-Day Centurion!';
      body = '100 days of devotion! Your dedication is a beautiful testament of faith.';
    } else if (streakCount % 50 == 0) {
      title = '🌟 Awesome $streakCount-Day Streak!';
      body = 'Your dedication is incredible. Keep resting in His presence daily!';
    } else {
      return; // Not a milestone
    }

    await _notificationsPlugin.show(
      1, // ID for milestones
      title,
      body,
      notificationDetails,
    );
  }

  /// Show an immediate test notification to verify basic functionality
  static Future<void> showImmediateTestNotification() async {
    if (kIsWeb) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Channel for testing notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      99,
      '🔔 Test Notification',
      'If you see this, notifications are working perfectly! 🙏',
      notificationDetails,
      payload: 'read_payload',
    );
  }

  /// Cancel all scheduled local notifications
  static Future<void> cancelNotifications() async {
    if (kIsWeb) return;
    await _notificationsPlugin.cancelAll();
  }
}
