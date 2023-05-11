import 'package:flutter/material.dart';

class SettingsField extends StatelessWidget {
  final String title;
  final String description;
  final Function() onPressed;
  final Widget trailingWidget;

  const SettingsField({
    super.key,
    required this.title,
    required this.description,
    required this.trailingWidget,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: Border(
            bottom: BorderSide(width: 0.1, color: Theme.of(context).hintColor)
        ),
        color: Colors.transparent,
        margin: EdgeInsets.zero,
        elevation: 0.0,
        child: InkWell(
            onTap: onPressed,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).hintColor
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              description,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor.withOpacity(0.6),
                                fontWeight: FontWeight.w300
                              ),
                            ),
                          ],
                        )
                    ),
                    trailingWidget
                  ],
                )
            )
        )
    );
  }
}