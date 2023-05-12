import 'package:flutter/material.dart';
import 'package:todo_app/ui/shapes.dart';

class BottomSheetCheckbox extends StatelessWidget {
  final String label;
  final bool checked;
  final Function(bool?)? onPressed;
  final bool enabled;

  const BottomSheetCheckbox({super.key, required this.label, required this.checked, this.onPressed, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: AppShapes.roundedRectangleShape,
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.transparent,
      child: InkWell(
          onTap: enabled
              ? () {
                  onPressed!(!checked);
                }
              : null,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: checked,
                      onChanged: enabled ? onPressed : null,
                      shape: AppShapes.smallRoundedRectangleShape,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: TextStyle(fontSize: 16, color: enabled ? Theme.of(context).hintColor : Theme.of(context).disabledColor),
                  )
                ],
              ))),
    );
  }
}
