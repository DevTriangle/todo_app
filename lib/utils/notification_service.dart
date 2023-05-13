import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_app/ui/screens/home_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future selectNotification(String? payload) async {
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => const HomeScreen()),
    // );
  }

  Future<bool> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);

    return true;
  }

  Future<void> scheduleNotifications(int id, String title, String body, bool playSound, DateTime dateTime, BuildContext context) async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails("0", AppLocalizations.of(context).channel_name,
        channelDescription: AppLocalizations.of(context).channel_description, playSound: playSound, priority: Priority.high, importance: Importance.high);

    DarwinNotificationDetails iosNotificationDetails = const DarwinNotificationDetails(
      badgeNumber: 0,
      attachments: [],
    );

    tz.TZDateTime time = tz.TZDateTime.from(dateTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id, title, body, time, NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }
}
