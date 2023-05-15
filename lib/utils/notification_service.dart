import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:todo_app/model/app_event.dart';
import 'package:todo_app/ui/screens/home_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/repeat.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_notifications');

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (n) {
      print(n.payload);
    });
  }

  Future selectNotification(String? payload) async {}

  Future<bool> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    print(id);

    return true;
  }

  Future<List<AppNotification>> scheduleNotifications(String title, String body, DateTime dateTime, BuildContext context, Repeat repeat) async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails("0", AppLocalizations.of(context).channel_name,
        channelDescription: AppLocalizations.of(context).channel_description, priority: Priority.high, importance: Importance.high);

    DarwinNotificationDetails iosNotificationDetails = const DarwinNotificationDetails(
      badgeNumber: 0,
      attachments: [],
    );

    List<AppNotification> notifications = [];

    switch (repeat.type) {
      case "1d":
        {
          int id = Random().nextInt(2147483647);
          tz.TZDateTime time = tz.TZDateTime.from(dateTime, tz.local);

          await flutterLocalNotificationsPlugin.periodicallyShow(
            id,
            title,
            body,
            time,
            RepeatInterval.daily,
            NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails),
          );
          notifications.add(AppNotification(id, DateTime.parse(time.toString()).toString()));

          int id2 = Random().nextInt(2147483647);
          await flutterLocalNotificationsPlugin.zonedSchedule(
              id2, title, body, time, NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails),
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
          notifications.add(AppNotification(id2, DateTime.parse(time.toString()).toString()));
        }
        break;
      case "1w":
        {
          int id = Random().nextInt(2147483647);
          tz.TZDateTime time = tz.TZDateTime.from(dateTime, tz.local);
          await flutterLocalNotificationsPlugin.periodicallyShow(
            id,
            title,
            body,
            time,
            RepeatInterval.weekly,
            NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails),
          );
          notifications.add(AppNotification(id, DateTime.parse(time.toString()).toString()));

          int id2 = Random().nextInt(2147483647);
          await flutterLocalNotificationsPlugin.zonedSchedule(
              id2, title, body, time, NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails),
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
          notifications.add(AppNotification(id2, DateTime.parse(time.toString()).toString()));
        }
        break;
      case "1m":
        {
          tz.TZDateTime time = tz.TZDateTime.from(dateTime, tz.local);
          for (int i = 0; i < 12; i++) {
            int id = Random().nextInt(2147483647);

            print("m" + DateTime.parse(time.toString()).toString());

            await flutterLocalNotificationsPlugin.zonedSchedule(
                id, title, body, time, NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails),
                uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);

            notifications.add(AppNotification(id, DateTime.parse(time.toString()).toString()));
            time = tz.TZDateTime.from(Jiffy(time).add(months: 1).dateTime, tz.local);
          }
        }
        break;
      case "1y":
        {
          tz.TZDateTime time = tz.TZDateTime.from(dateTime, tz.local);
          for (int i = 0; i < 3; i++) {
            int id = Random().nextInt(2147483647);
            print("y" + DateTime.parse(time.toString()).toString());

            await flutterLocalNotificationsPlugin.zonedSchedule(
                id, title, body, time, NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails),
                uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);

            notifications.add(AppNotification(id, DateTime.parse(time.toString()).toString()));
            time = tz.TZDateTime.from(Jiffy(time).add(years: 1).dateTime, tz.local);
          }
        }
        break;
      case "no":
        {
          int id = Random().nextInt(2147483647);

          tz.TZDateTime time = tz.TZDateTime.from(dateTime, tz.local);

          await flutterLocalNotificationsPlugin.zonedSchedule(
              id, title, body, time, NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails),
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);

          notifications.add(AppNotification(id, DateTime.parse(time.toString()).toString()));
        }
        break;
    }

    return notifications;
  }
}
