import 'package:flutter/material.dart';

import '../shapes.dart';

class BottomSheetCard extends StatelessWidget {
  final List<Widget> children;
  final String? label;

  const BottomSheetCard({
    super.key,
    required this.children,
    this.label
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
        children: [
          Card(
              margin: const EdgeInsets.all(10),
              shape: AppShapes.roundedRectangleShape,
              clipBehavior: Clip.antiAlias,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: AppShapes.borderRadius,
                        color: Theme.of(context).hintColor.withOpacity(0.4),
                      ),
                    ),
                    label != null ? Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        label!,
                        style: TextStyle(
                            color: Theme.of(context).hintColor.withOpacity(0.7),
                            fontSize: 14
                        ),
                      ),
                    ): const SizedBox(height: 10),
                    Column(
                      children: children,
                    ),
                    const SizedBox(height: 10)
                  ]
              )
          )
        ]
    );
  }
}