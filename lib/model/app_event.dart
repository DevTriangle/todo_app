import 'package:todo_app/model/event_category.dart';
import 'package:todo_app/model/repeat.dart';

class AppEvent {
  final int id;
  final String title;
  final String? description;
  final EventCategory eventCategory;
  String datetime;
  final bool disableNotifications;
  List<AppNotification> notifications;
  final List<String> reminders;
  final Repeat repeat;

  AppEvent({
    required this.id,
    required this.title,
    this.description,
    required this.eventCategory,
    required this.datetime,
    required this.disableNotifications,
    required this.reminders,
    required this.notifications,
    required this.repeat,
  });

  factory AppEvent.fromJson(Map<String, dynamic> json) {
    List<AppNotification> nots = [];

    json.forEach((key, value) {
      if (key == "notifications") {
        value.forEach((element) {
          nots.add(AppNotification.fromJson(element));
        });
      }
    });

    return AppEvent(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        eventCategory: EventCategory.fromJson(json['eventCategory']),
        datetime: json['datetime'],
        disableNotifications: json['disableNotifications'],
        notifications: nots,
        reminders: List<String>.from(json['reminders']),
        repeat: Repeat.fromJson(json['repeat']));
  }

  Map toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'eventCategory': eventCategory.toJson(),
        'datetime': datetime,
        'disableNotifications': disableNotifications,
        'notifications': notifications,
        'reminders': reminders,
        'repeat': repeat
      };
}

class AppNotification {
  final int id;
  final String time;

  AppNotification(this.id, this.time);

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(json['id'], json['time']);
  }

  Map toJson() => {'id': id, 'time': time};
}

class EventPayload {
  final String title;
  final String body;
  final DateTime dateTime;
  final Repeat repeat;

  EventPayload({
    required this.title,
    required this.body,
    required this.dateTime,
    required this.repeat,
  });

  factory EventPayload.fromJson(Map<String, dynamic> json) {
    return EventPayload(
      title: json['title'],
      body: json['body'],
      dateTime: DateTime.parse(json['dateTime']),
      repeat: json['repeat'],
    );
  }

  Map toJson() => {
        'title': title,
        'body': body,
        'dateTime': dateTime.toString(),
        'repeat': repeat,
      };
}
