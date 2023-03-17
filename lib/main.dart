import 'package:flutter/material.dart';
import 'package:todo_app/ui/colors.dart';
import 'package:todo_app/ui/screens/home_screen.dart';

Future<void> main() async {
  runApp(MyApp(

  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DateTo',
      theme: ThemeData.light(useMaterial3: true).copyWith(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.primarySwatch).copyWith(
          background: AppColors.lightBackgroundColor,
          surface: AppColors.lightCardColor
        ),
        canvasColor: AppColors.lightBackgroundColor,
        scaffoldBackgroundColor: AppColors.lightBackgroundColor,
        hintColor: AppColors.lightTextColor,
        cardColor: AppColors.lightTertiaryColor,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.primarySwatch).copyWith(
            background: AppColors.darkBackgroundColor,
            surface: AppColors.darkCardColor
        ),
        canvasColor: AppColors.darkBackgroundColor,
        scaffoldBackgroundColor: AppColors.darkBackgroundColor,
        hintColor: AppColors.darkTextColor,
        cardColor: AppColors.darkTertiaryColor,
      ),
      themeMode: ThemeMode.system,
      home: HomeScreen(),
      builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!),
    );
  }
}