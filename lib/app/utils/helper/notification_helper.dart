import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

   Future<void> initializeNotification() async {
    tz.initializeTimeZones(); // Initialize timezone data
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Create notification channel for Android 8.0 and above
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'task_channel', // id
      'Task Notifications', // name
      description: 'Reminders for scheduled tasks',
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> scheduleNotification(int id, String title, String description, DateTime scheduledTime) async {
    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    debugPrint('Scheduling notification for $tzScheduledTime');
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id, // Unique ID for notification
      title,
      description,
      tzScheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel', // Channel ID from initialization
          'Task Notifications',
          channelDescription: 'Reminders for scheduled tasks',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    debugPrint('Notification scheduled successfully');
  }
}