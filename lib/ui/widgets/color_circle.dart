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
        margin: const EdgeInsets.all(2),
        child: InkWell(
          onTap: () {
            onSelect(color);
          },
          child: Card(
            margin: const EdgeInsets.all(2),
            color: Colors.transparent,
            elevation: 0,
            shape: isSelected == true ? CircleBorder(
              side: BorderSide(
                  width: 2,
                  color: Theme.of(context).colorScheme.primary,
                  strokeAlign: StrokeAlign.outside
              ),
            ) : null,
            child: SizedBox(
              width: 50, height: 50,
              child: Card(
                shape: AppShapes.circleShape,
                elevation: 0,
                margin: const EdgeInsets.all(2),
                color: color,
              ),
            ),
          ),
        )
    );
  }
}