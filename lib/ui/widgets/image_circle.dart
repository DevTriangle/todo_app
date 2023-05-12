import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../shapes.dart';

class ImageCircle extends StatelessWidget {
  final String image;
  final bool isSelected;
  final Function() onSelect;

  const ImageCircle({
    super.key,
    required this.image,
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
            onSelect();
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
              width: 50, height: 50,
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Image.asset(
                  image,
                  width: 18.0, height: 18.0,
                  fit: BoxFit.contain,
                ),
              ) 
            ),
          ),
        )
    );
  }
}