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
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.primarySwatch).copyWith(
            background: AppColors.darkBackgroundColor,
            surface: AppColors.darkCardColor
        ),
        canvasColor: AppColors.darkBackgroundColor,
          scaffoldBackgroundColor: AppColors.darkBackgroundColor,
      ),
      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}