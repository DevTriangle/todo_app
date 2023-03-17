import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/ui/icons.dart';
import 'package:todo_app/ui/shapes.dart';

class IconCircle extends StatelessWidget {
  final int iconID;
  final bool isSelected;
  final Function(int) onSelect;

  const IconCircle({
    super.key,
    required this.iconID,
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
            onSelect(iconID);
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
              width: 25, height: 25,
              child: Icon(
                AppIcons().iconsList[iconID],
                size: 18,
              )
            ),
          ),
        )
    );
  }
}