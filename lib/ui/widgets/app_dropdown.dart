import 'package:flutter/material.dart';
import 'package:todo_app/model/event_category.dart';
import 'package:todo_app/ui/shapes.dart';

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
                      Icon(
                        item.categoryIcon,
                        color: item.categoryColor,
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