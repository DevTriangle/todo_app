import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/ui/icons.dart';
import 'package:todo_app/ui/shapes.dart';

class IconCircle extends StatelessWidget {
  final int iconID;
  final bool isSelected;
  final Function(int) onSelect;
  final Color selectedColor;

  const IconCircle({
    super.key,
    required this.iconID,
    required this.isSelected,
    required this.onSelect,
    required this.selectedColor,
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
            onSelect(iconID);
          },
          child: Card(
            margin: const EdgeInsets.all(2),
            color: Colors.transparent,
            shape: isSelected == true ? CircleBorder(
              side: BorderSide(
                  width: 2,
                  color: Theme.of(context).colorScheme.primary,
                  strokeAlign: BorderSide.strokeAlignOutside
              ),
            ) : null,
            elevation: 0,
            child: SizedBox(
              width: 60, height: 60,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  AppIcons().iconsList[iconID],
                  width: 18.0, height: 18.0,
                  fit: BoxFit.contain,
                  color: selectedColor,
                ),
              ) 
            ),
          ),
        )
    );
  }
}