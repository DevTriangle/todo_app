import 'dart:html';
import 'dart:ui';

import 'package:todo_app/model/event_category.dart';

class Event {
  final String title;
  final EventCategory eventCategory;
  final Color eventColor;

  Event({
    required this.title,
    required this.eventCategory,
    required this.eventColor,
  });
}