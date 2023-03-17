import 'package:flutter/material.dart';

class AppColors {
  static const int primaryColor = 0xFF3C8AFF;
  static const MaterialColor primarySwatch = MaterialColor(
      primaryColor,
      <int, Color>{
        50:  Color.fromRGBO(60, 138, 255, 0.1),
        100: Color.fromRGBO(60, 138, 255, 0.2),
        200: Color.fromRGBO(60, 138, 255, 0.3),
        300: Color.fromRGBO(60, 138, 255, 0.4),
        400: Color.fromRGBO(60, 138, 255, 0.5),
        500: Color.fromRGBO(60, 138, 255, 0.6),
        600: Color.fromRGBO(60, 138, 255, 0.7),
        700: Color.fromRGBO(60, 138, 255, 0.8),
        800: Color.fromRGBO(60, 138, 255, 0.9),
        900: Color.fromRGBO(60, 138, 255, 1.0)
      });

  static Color acceptColor = const Color(0xFF009114);

  static Color lightBackgroundColor = const Color(0xFFF0F0F0);
  static Color lightCardColor = const Color(0xFFFFFFFF);
  static Color lightTertiaryColor = const Color(0xFFF3F3F3);
  static Color lightSecondaryColor = const Color(0xFF4D75B7);
  static Color lightOnSecondaryColor = const Color(0xFF2A7AD1);
  static Color lightTextColor = const Color(0xFF1E1E1E);
  static Color lightShimmerColor = const Color(0xFFEBEBEB);
  static Color lightDisabledColor = const Color(0xFF808080);
  static Color lightErrorColor = const Color(0xFFEE3838);

  static Color darkBackgroundColor = const Color(0xFF101014);
  static Color darkCardColor = const Color(0xFF1E1E1E);
  static Color darkTertiaryColor = const Color(0xFF343434);
  static Color darkSecondaryColor = const Color(0xFF73AEFF);
  static Color darkOnSecondaryColor = const Color(0xFFA0CDFF);
  static Color darkTextColor = const Color(0xFFF7F7F7);
  static Color darkShimmerColor = const Color(0xFF282828);
  static Color darkDisabledColor = const Color(0xFF808080);
  static Color darkErrorColor = const Color(0xFFEF6055);
}