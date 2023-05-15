// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/model/app_event.dart';
import 'package:todo_app/model/event_category.dart';
import 'package:todo_app/model/repeat.dart';
import 'package:todo_app/model/response.dart';
import 'package:todo_app/utils/notification_service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeViewModel extends ChangeNotifier {
  DateFormat date = DateFormat("dd.MM.yyyy HH:mm");

  List<AppEvent> eventList = <AppEvent>[];
  List<EventCategory> categoryList = [];
  List<Repeat> repeatList = [
    Repeat("Не повторяется", "no"),
  ];

  late BuildContext _context;

  set context(BuildContext value) {
    _context = value;

    repeatList = [
      Repeat(AppLocalizations.of(_context).repeat_no, "no"),
      Repeat(AppLocalizations.of(_context).repeat1d, "1d"),
      Repeat(AppLocalizations.of(_context).repeat1w, "1w"),
      Repeat(AppLocalizations.of(_context).repeat1m, "1m"),
      Repeat(AppLocalizations.of(_context).repeat1y, "1y"),
    ];

    categoryList = <EventCategory>[
      EventCategory(categoryTitle: AppLocalizations.of(_context).category_1, categoryIconID: 0, categoryColor: Colors.amber.value),
      EventCategory(categoryTitle: AppLocalizations.of(_context).category_2, categoryIconID: 1, categoryColor: Colors.redAccent.value),
      EventCategory(categoryTitle: AppLocalizations.of(_context).category_3, categoryIconID: 2, categoryColor: Colors.grey.value),
    ];
  }

  Future<Response> loadEvents() async {
    eventList.clear();

    try {
      final prefs = await SharedPreferences.getInstance();

      final eventJson = prefs.getString("events");

      if (eventJson == null || eventJson == "[]") {
        throw "list-null";
      } else {
        Iterable l = json.decode(eventJson);
        List<AppEvent> events = List.from(l.map((e) => AppEvent.fromJson(e)));

        eventList.addAll(events.where((event) {
          if (event.repeat.type == "no") {
            return DateTime.parse(event.datetime).add(const Duration(days: 3)).isAfter(DateTime.now());
          } else {
            return true;
          }
        }));
        eventList.sort((a, b) => DateTime.parse(a.datetime).compareTo(DateTime.parse(b.datetime)));
      }

      if (eventList.isNotEmpty) {
        for (var e in eventList) {
          DateTime dt = DateTime.parse(e.datetime);
          while (DateTime.parse(e.datetime).isBefore(DateTime.now())) {
            DateTime time = DateTime.parse(e.datetime);
            if (time.isBefore(DateTime.now()) && e.repeat.type != "") {
              switch (e.repeat.type) {
                case "1d":
                  {
                    e.datetime = Jiffy(time).add(days: 1).dateTime.toString();
                  }
                  break;
                case "1w":
                  {
                    e.datetime = Jiffy(time).add(weeks: 1).dateTime.toString();
                  }
                  break;
                case "1m":
                  {
                    e.datetime = Jiffy(time).add(months: 1).dateTime.toString();
                    print(e.datetime);
                  }
                  break;
                case "1y":
                  {
                    e.datetime = Jiffy(time).add(years: 1).dateTime.toString();
                  }
                  break;
              }
            }
          }
        }

        for (var e in eventList) {
          print(e.notifications.last.time);
          if (e.notifications.isNotEmpty &&
              DateTime.parse(e.notifications.last.time).isBefore(DateTime.now()) &&
              (e.repeat.type != "no" || e.repeat.type != "1d" || e.repeat.type != "1w")) {
            print("1");

            e.notifications = await scheduleNotifications(
              e.title,
              DateTime.parse(e.datetime),
              e.repeat,
              e.reminders.contains("5m"),
              e.reminders.contains("10m"),
              e.reminders.contains("15m"),
              e.reminders.contains("30m"),
              e.reminders.contains("1h"),
              e.reminders.contains("4h"),
              e.reminders.contains("1d"),
            );
          }
        }

        await saveEvents(eventList);

        return Response(isSuccess: true, message: AppLocalizations.of(_context).events_loaded, code: 0);
      } else {
        throw "list-null";
      }
    } catch (e) {
      if (e.toString() == "list-null") {
        return Response(isSuccess: false, message: AppLocalizations.of(_context).events_empty, code: 1);
      } else {
        return Response(isSuccess: false, message: e.toString(), code: -1);
      }
    }
  }

  Future<Response> createEvent(AppEvent event) async {
    eventList.add(event);

    Response response = await saveEvents(eventList);

    return response;
  }

  Future<Response> saveEvents(List<AppEvent> eList) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      prefs.setString("events", jsonEncode(eList.map((e) => e.toJson()).toList()));

      return Response(isSuccess: true, message: AppLocalizations.of(_context).saved, code: 0);
    } catch (e) {
      return Response(isSuccess: false, message: e.toString(), code: -1);
    }
  }

  Future<Response> editEvent(int index, AppEvent event) async {
    eventList.removeAt(index);
    eventList.insert(index, event);

    for (var e in event.notifications) {
      await NotificationService().cancelNotification(e.id);
    }

    scheduleNotifications(
      event.title,
      DateTime.parse(event.datetime),
      event.repeat,
      event.reminders.contains("5m"),
      event.reminders.contains("10m"),
      event.reminders.contains("15m"),
      event.reminders.contains("30m"),
      event.reminders.contains("1h"),
      event.reminders.contains("4h"),
      event.reminders.contains("1d"),
    );

    Response response = await saveEvents(eventList);
    return response;
  }

  Future<Response> removeEvent(AppEvent event) async {
    eventList.remove(event);

    for (var e in event.notifications) {
      await NotificationService().cancelNotification(e.id);
    }

    await NotificationService().cancelNotification(event.id);

    Response response = await saveEvents(eventList);

    return response;
  }

  Future<Response> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstLoad = prefs.getBool("isFirstLoad") ?? true;

    if (!isFirstLoad) {
      categoryList.clear();
    } else {
      saveCategories(categoryList);
      await prefs.setBool("isFirstLoad", false);

      return Response(isSuccess: true, message: AppLocalizations.of(_context).categories_loaded, code: 0);
    }

    try {
      final prefs = await SharedPreferences.getInstance();

      final eventJson = prefs.getString("categories");

      if (eventJson == null) {
        throw "list-null";
      } else {
        Iterable l = json.decode(eventJson);
        List<EventCategory> categories = List.from(l.map((e) => EventCategory.fromJson(e)));

        categoryList.addAll(categories);
      }

      return Response(isSuccess: true, message: AppLocalizations.of(_context).categories_loaded, code: 0);
    } catch (e) {
      if (e.toString() == "list-null") {
        return Response(isSuccess: true, message: AppLocalizations.of(_context).categories_empty, code: 1);
      } else {
        return Response(isSuccess: false, message: e.toString(), code: -1);
      }
    }
  }

  Future<Response> createCategory(EventCategory category) async {
    categoryList.add(category);

    Response response = await saveCategories(categoryList);

    return response;
  }

  Future<Response> editCategory(int index, EventCategory category) async {
    categoryList.removeAt(index);
    categoryList.insert(index, category);

    Response response = await saveCategories(categoryList);

    return response;
  }

  Future<Response> removeCategory(EventCategory category) async {
    categoryList.remove(category);

    Response response = await saveCategories(categoryList);

    return response;
  }

  Future<Response> saveCategories(List<EventCategory> catList) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      prefs.setString("categories", jsonEncode(catList.map((e) => e.toJson()).toList()));

      return Response(isSuccess: true, message: AppLocalizations.of(_context).saved, code: 0);
    } catch (e) {
      return Response(isSuccess: false, message: e.toString(), code: -1);
    }
  }

  Future<List<AppNotification>> scheduleNotifications(
    String eventTitle,
    DateTime dateTime,
    Repeat selectedRepeat,
    bool fiveChecked,
    bool tenChecked,
    bool fifteenChecked,
    bool thirtyChecked,
    bool hourChecked,
    bool fourHChecked,
    bool dayChecked,
  ) async {
    List<AppNotification> notifications = [];

    if (fiveChecked) {
      notifications.addAll(await NotificationService().scheduleNotifications(
          eventTitle, "${AppLocalizations.of(_context).start_5min} \"$eventTitle\"", dateTime.subtract(const Duration(minutes: 5)), _context, selectedRepeat));
    }

    if (tenChecked) {
      notifications.addAll(
        await NotificationService().scheduleNotifications(eventTitle, "${AppLocalizations.of(_context).start_10min} \"$eventTitle\"",
            dateTime.subtract(const Duration(minutes: 10)), _context, selectedRepeat),
      );
    }
    if (fifteenChecked) {
      notifications.addAll(
        await NotificationService().scheduleNotifications(eventTitle, "${AppLocalizations.of(_context).start_15min} \"$eventTitle\"",
            dateTime.subtract(const Duration(minutes: 15)), _context, selectedRepeat),
      );
    }
    if (thirtyChecked) {
      notifications.addAll(
        await NotificationService().scheduleNotifications(eventTitle, "${AppLocalizations.of(_context).start_30min} \"$eventTitle\"",
            dateTime.subtract(const Duration(minutes: 30)), _context, selectedRepeat),
      );
    }
    if (hourChecked) {
      notifications.addAll(
        await NotificationService().scheduleNotifications(
            eventTitle, "${AppLocalizations.of(_context).start_1h} \"$eventTitle\"", dateTime.subtract(const Duration(hours: 1)), _context, selectedRepeat),
      );
    }

    if (fourHChecked) {
      notifications.addAll(
        await NotificationService().scheduleNotifications(
            eventTitle, "${AppLocalizations.of(_context).start_4h} \"$eventTitle\"", dateTime.subtract(const Duration(hours: 4)), _context, selectedRepeat),
      );
    }

    if (dayChecked) {
      notifications.addAll(
        await NotificationService().scheduleNotifications(
            eventTitle, "${AppLocalizations.of(_context).start_1d} \"$eventTitle\"", dateTime.subtract(const Duration(days: 1)), _context, selectedRepeat),
      );
    }

    notifications.addAll(
      await NotificationService().scheduleNotifications(eventTitle, AppLocalizations.of(_context).event_start, dateTime, _context, selectedRepeat),
    );

    return notifications;
  }
}
