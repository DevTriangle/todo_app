import 'package:todo_app/model/event_category.dart';

class AppEvent {
  final String id;
  final String title;
  final EventCategory eventCategory;
  final String datetime;
  final bool disableNotifications;

  AppEvent({
    required this.id,
    required this.title,
    required this.eventCategory,
    required this.datetime,
    required this.disableNotifications,
  });

  factory AppEvent.fromJson(Map<String, dynamic> json) {
    return AppEvent(
      id: json['id'],
      title: json['title'],
      eventCategory: EventCategory.fromJson(json['eventCategory']),
      datetime: json['datetime'],
      disableNotifications: json['disableNotifications'],
    );
  }

  Map toJson() => {
        'id': id,
        'title': title,
        'eventCategory': eventCategory.toJson(),
        'datetime': datetime,
        'disableNotifications': disableNotifications,
      };
}
