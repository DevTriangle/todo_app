import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/model/event_category.dart';
import 'package:todo_app/ui/shapes.dart';

import '../icons.dart';

class CategoryDropdown extends StatelessWidget {
  final EventCategory value;
  final List<EventCategory> items;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final void Function(EventCategory item)? onChanged;

  const CategoryDropdown({
    super.key,
    required this.value,
    required this.items,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
    this.margin = const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.5),
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: AppShapes.borderRadius
        ),
        width: double.infinity,
        padding: padding,
        margin: margin,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<EventCategory>(
              borderRadius: AppShapes.borderRadius,
              dropdownColor: Theme.of(context).cardColor,
              items: items.map((EventCategory item) {
                return DropdownMenuItem<EventCategory>(
                  value: item,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons().iconsList[item.categoryIconID],
                        color: Color(item.categoryColor),
                        fit: BoxFit.contain,
                        width: 19.0, height: 19.0,
                        clipBehavior: Clip.antiAlias,
                      ),
                      const SizedBox(width: 10),
                      Text(item.categoryTitle)
                    ],
                  ),
                );
              }).toList(),
              value: value,
              style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.w500
              ),
              onChanged: onChanged != null ? (item) => onChanged!(item!) : null
          ),
        )
    );
  }
}

class AppDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final void Function(String item)? onChanged;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
    this.margin = const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.5),
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: AppShapes.borderRadius
        ),
        width: double.infinity,
        padding: padding,
        margin: margin,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
              borderRadius: AppShapes.borderRadius,
              dropdownColor: Theme.of(context).cardColor,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item)
                );
              }).toList(),
              value: value,
              style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.w500
              ),
              onChanged: onChanged != null ? (item) => onChanged!(item!) : null
          ),
        )
    );
  }
}