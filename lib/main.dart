import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/ui/colors.dart';
import 'package:todo_app/ui/screens/home_screen.dart';
import 'package:todo_app/viewmodel/home_viewmodel.dart';

Future<void> main() async {
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => HomeViewModel())
          ],
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DateTo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.primarySwatch).copyWith(
            brightness: Brightness.light,
            background: AppColors.lightBackgroundColor,
            surface: AppColors.lightCardColor
        ),
        canvasColor: AppColors.lightBackgroundColor,
        scaffoldBackgroundColor: AppColors.lightBackgroundColor,
        hintColor: AppColors.lightTextColor,
        cardColor: AppColors.lightTertiaryColor,
        fontFamily: "Rubik",
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.primarySwatch).copyWith(
            brightness: Brightness.dark,
            background: AppColors.darkBackgroundColor,
            surface: AppColors.darkCardColor
        ),
        canvasColor: AppColors.darkBackgroundColor,
        scaffoldBackgroundColor: AppColors.darkBackgroundColor,
        hintColor: AppColors.darkTextColor,
        cardColor: AppColors.darkTertiaryColor,
        fontFamily: "Rubik",
      ),
      themeMode: ThemeMode.system,
      home: HomeScreen(),
      builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!),
    );
  }
}