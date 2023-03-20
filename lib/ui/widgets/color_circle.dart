import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/ui/shapes.dart';

class ColorCircle extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final Function(Color) onSelect;

  const ColorCircle({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: AppShapes.circleShape,
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.all(2),
        child: InkWell(
          onTap: () {
            onSelect(color);
          },
          child: Card(
            margin: EdgeInsets.all(2),
            color: Colors.transparent,
            shape: isSelected == true ? CircleBorder(
              side: BorderSide(
                  width: 2,
                  color: Theme.of(context).colorScheme.primary,
                  strokeAlign: StrokeAlign.outside
              ),
            ) : null,
            elevation: 0,
            child: Container(
              width: 40, height: 40,
              child: Card(
                shape: AppShapes.circleShape,
                margin: const EdgeInsets.all(2),
                color: color,
              ),
            ),
          ),
        )
    );
  }
}