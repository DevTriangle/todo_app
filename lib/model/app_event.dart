import 'package:todo_app/model/event_category.dart';

class AppEvent {
  final int id;
  final String title;
  final String? description;
  final EventCategory eventCategory;
  final String datetime;
  final bool disableNotifications;
  final List<AppNotification> notifications;

  AppEvent(
      {required this.id,
      required this.title,
      this.description,
      required this.eventCategory,
      required this.datetime,
      required this.disableNotifications,
      required this.notifications});

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
    );
  }

  Map toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'eventCategory': eventCategory.toJson(),
        'datetime': datetime,
        'disableNotifications': disableNotifications,
        'notifications': notifications,
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
