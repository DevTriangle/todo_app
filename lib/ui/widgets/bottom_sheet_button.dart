import 'package:flutter/material.dart';
import 'package:todo_app/ui/shapes.dart';

class BottomSheetButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final Function()? onPressed;

  const BottomSheetButton({
    super.key,
    required this.icon,
    required this.label,
    this.color,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: AppShapes.roundedRectangleShape,
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.transparent,
      child: InkWell(
          onTap: onPressed,
          child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                      icon,
                      color: color ?? Theme.of(context).hintColor,
                  ),
                  const SizedBox(width: 10),
                  Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16
                      ),
                  )
                ],
              )
          )
      ),
    );
  }
}