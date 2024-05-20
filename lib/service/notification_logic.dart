import 'package:flutter/material.dart';
import 'package:flutter_diet_app/pages/reminders_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationLogic {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "schedule_reminder",
        "Schedule Reminder",
        channelDescription: "This channel is for schedule reminders",
        importance: Importance.max,
        priority: Priority.max,
      ),
    );
  }

  static Future init(BuildContext context, String uid) async {
    tz.initializeTimeZones();
    const android = AndroidInitializationSettings("mipmap/ic_launcher");
    const settings = InitializationSettings(android: android);
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse payload) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ReminderScreen(
                    userId: uid,
                  )),
        );
        onNotifications.add(payload.payload);
      },
      onDidReceiveBackgroundNotificationResponse:
          (NotificationResponse payload) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ReminderScreen(
                    userId: uid,
                  )),
        );
        onNotifications.add(payload.payload);
      },
    );
  }

  static Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
    required String payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );

  static Future<void> scheduleNotification({
    int id = 0,
    required String title,
    required String body,
    required String payload,
    required DateTime scheduledDateTime,
    required int categoryIndex,
  }) async {
    tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      scheduledDateTime,
      tz.local,
    );

    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    String notificationBody;
    if (categoryIndex == 0) {
      notificationBody =
          'Hadi Hareket Zamanı! Vücudun sana teşekkür edecek!🏃🏼‍♀️🏋🏼🚴🏼‍♀️';
    } else if (categoryIndex == 1) {
      notificationBody =
          'Su İçme Zamanı! Gün boyu enerji için su içmeyi unutma!💧';
    } else {
      notificationBody = 'Hatırlatma Zamanı Geldi!';
    }

    await _notifications.zonedSchedule(
      id,
      title,
      notificationBody,
      scheduledDate,
      await _notificationDetails(),
      androidAllowWhileIdle: true,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  static Future<void> unScheduleAllNotifications() async =>
      await _notifications.cancelAll();
}
