import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static Future<void> initializeNotifications() async {
    tz.initializeTimeZones();
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );
    await _notificationsPlugin.initialize(initializationSettings);
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'reminders_channel',
      "Reminders",
      description: 'Channel for Reminder Notifications',
      importance: Importance.high,
      playSound: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  static Future<void> scheduleNotification(
    int id,
    String title,
    String category,
    DateTime scheduledTime,
  ) async {
    const androidDetails = AndroidNotificationDetails(
      'reminders_channel',
      "Reminders",
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    final notificationDetails = NotificationDetails(android: androidDetails);
    if (scheduledTime.isBefore(DateTime.now())) {
    } else {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        category,
        tz.TZDateTime.from(scheduledTime, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}
