import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shapes.dart';

class AppTextButton extends StatelessWidget {
  final String label;
  final Function() onPressed;

  const AppTextButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.transparent,
      hoverColor: Theme.of(context).errorColor.withOpacity(0.1),
      highlightColor: Colors.transparent,
      elevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      focusElevation: 0,
      shape: AppShapes.circleShape,
      splashColor: Theme.of(context).errorColor.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Text(
          label,
          style: TextStyle(color: Theme.of(context).errorColor),
        ),
      ) ,
    );
  }
}

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final Function() onPressed;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: AppShapes.circleShape,
        color: Colors.transparent,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                  icon,
                  color: Theme.of(context).hintColor
              ),
            )
        )
    );
  }
}