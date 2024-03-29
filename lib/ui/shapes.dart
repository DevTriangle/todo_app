import 'package:flutter/material.dart';

class AppShapes {
  static double radius = 12.0;
  static double smallRadius = 3.0;
  static BorderRadius borderRadius = BorderRadius.circular(radius);
  static BorderRadius smallBorderRadius = BorderRadius.circular(smallRadius);

  static RoundedRectangleBorder roundedRectangleShape = RoundedRectangleBorder(
      borderRadius: borderRadius
  );

  static RoundedRectangleBorder smallRoundedRectangleShape = RoundedRectangleBorder(
      borderRadius: smallBorderRadius
  );

  static RoundedRectangleBorder circleShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10000))
  );
}