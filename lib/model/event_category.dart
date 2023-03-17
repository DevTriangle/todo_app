import 'package:flutter/cupertino.dart';

class EventCategory {
  final String categoryTitle;
  final int categoryIconID;
  final int categoryColor;

  EventCategory({
    required this.categoryTitle,
    required this.categoryIconID,
    required this.categoryColor,
  });

  factory EventCategory.fromJson(Map<String, dynamic> json) {
    return EventCategory(
        categoryTitle: json['categoryTitle'],
        categoryIconID: json['categoryIcon'],
        categoryColor: json['categoryColor']
    );
  }

  Map toJson() => {
    'categoryTitle': categoryTitle,
    'categoryIcon': categoryIconID,
    'categoryColor': categoryColor
  };
}