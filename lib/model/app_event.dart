import 'package:todo_app/model/event_category.dart';

class AppEvent {
  final String title;
  final EventCategory eventCategory;
  final String datetime;

  AppEvent({
    required this.title,
    required this.eventCategory,
    required this.datetime,
  });

  factory AppEvent.fromJson(Map<String, dynamic> json) {
    return AppEvent(
        title: json['title'],
        eventCategory: EventCategory.fromJson(json['eventCategory']),
        datetime: json['datetime'],
    );
  }

  Map toJson() => {
      'title': title,
      'eventCategory': eventCategory.toJson(),
      'datetime': datetime,
  };
}