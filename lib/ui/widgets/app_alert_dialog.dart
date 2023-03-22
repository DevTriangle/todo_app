import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/ui/shapes.dart';
import 'package:todo_app/ui/widgets/app_button.dart';

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String description;
  final String confirmTitle;
  final Function() onConfirmPressed;
  final String dismissTitle;
  final Function() onDismissPressed;

  const AppAlertDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmTitle,
    required this.onConfirmPressed,
    required this.dismissTitle,
    required this.onDismissPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500
        ),
      ),
      content:  Text(
        description,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).hintColor.withOpacity(0.7)
        ),
      ),
      shape: AppShapes.roundedRectangleShape,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppTextButton(
              label: dismissTitle,
              onPressed: onDismissPressed,
            ),
            const SizedBox(width: 10),
            AppTextButton(
              label: confirmTitle,
              onPressed: onConfirmPressed,
              splashColor: Theme.of(context).errorColor.withOpacity(0.2),
              hoverColor: Theme.of(context).errorColor.withOpacity(0.1),
              textStyle: TextStyle(color: Theme.of(context).errorColor),
            )
          ],
        )
      ],
    );
  }
}