import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/model/app_event.dart';
import 'package:todo_app/model/event_category.dart';
import 'package:todo_app/model/response.dart';

class HomeViewModel extends ChangeNotifier {
  List<AppEvent> eventList = <AppEvent>[];
  List<EventCategory> categoryList =  <EventCategory>[
    EventCategory(categoryTitle: "Праздники", categoryIconID: 0, categoryColor: Colors.amber.value),
    EventCategory(categoryTitle: "Дни рождения", categoryIconID: 1, categoryColor: Colors.redAccent.value),
    EventCategory(categoryTitle: "Другое", categoryIconID: 2, categoryColor: Colors.grey.value),
  ];

  Future<Response> loadEvents() async {
    eventList.clear();

    try {
      final prefs = await SharedPreferences.getInstance();

      final eventJson = prefs.getString("events");

      print(eventJson.toString());

      if (eventJson == null) {
        throw "list-null";
      } else {
        Iterable l = json.decode(eventJson);
        List<AppEvent> events = List.from(l.map((e) => AppEvent.fromJson(e)));
        print(events);

        eventList.addAll(events);
        eventList.sort((a, b) => DateTime.parse(a.datetime).compareTo(DateTime.parse(b.datetime)));
      }

      return Response(isSuccess: true, message: "События загружены!", code: 0);
    } catch (e) {
      if (e.toString() == "list-null") {
        return Response(isSuccess: false, message: "События отсутсвуют!", code: 1);
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

      return Response(isSuccess: true, message: "Изменения сохранены!", code: 0);
    } catch (e) {
      return Response(isSuccess: false, message: e.toString(), code: -1);
    }
  }

  Future<Response> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstLoad  = prefs.getBool("isFirstLoad") ?? true;

    print(isFirstLoad);

    if (!isFirstLoad) {
      categoryList.clear();
    } else {
      prefs.setBool("isFirstLoad", false);
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

      return Response(isSuccess: true, message: "Категории загружены!", code: 0);
    } catch (e) {
      if (e.toString() == "list-null") {
        return Response(isSuccess: true, message: "Категории отсутсвуют!", code: 1);
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

  Future<Response> saveCategories(List<EventCategory> catList) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      prefs.setString("categories", jsonEncode(catList.map((e) => e.toJson()).toList()));

      return Response(isSuccess: true, message: "Изменения сохранены!", code: 0);
    } catch (e) {
      return Response(isSuccess: false, message: e.toString(), code: -1);
    }
  }
}