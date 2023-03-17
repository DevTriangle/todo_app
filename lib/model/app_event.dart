import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todo_app/model/event_category.dart';

class AppEvent {
  final String title;
  final EventCategory eventCategory;
  final String date;
  final String time;

  AppEvent({
    required this.title,
    required this.eventCategory,
    required this.date,
    required this.time,
  });

  factory AppEvent.fromJson(Map<String, dynamic> json) {
    return AppEvent(
        title: json['title'],
        eventCategory: EventCategory.fromJson(json['eventCategory']),
        date: json['date'],
        time: json['time']
    );
  }

  Map toJson() => {
      'title': title,
      'eventCategory': eventCategory.toJson(),
      'date': date,
      'time': time
  };
}