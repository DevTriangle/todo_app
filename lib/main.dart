import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/ui/colors.dart';
import 'package:todo_app/ui/screens/home_screen.dart';
import 'package:todo_app/utils/notification_service.dart';
import 'package:todo_app/viewmodel/home_viewmodel.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => HomeViewModel())],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => MyAppState();

  static MyAppState of(BuildContext context) => context.findAncestorStateOfType<MyAppState>()!;
}

class MyAppState extends State<MyApp> {
  late Locale _locale;

  void setLocale(String locale) async {
    setState(() {
      _locale = Locale(locale.split("_")[0]);
    });

    SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setString("locale", locale);
  }

  @override
  void initState() {
    super.initState();

    setLocale(Platform.localeName);

    SharedPreferences.getInstance().then((value) {
      String? locale = value.getString("locale");
      if (locale != null) {
        setLocale(locale);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      title: "Remains Until",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.primarySwatch)
            .copyWith(brightness: Brightness.light, background: AppColors.lightBackgroundColor, surface: AppColors.lightCardColor, outline: Colors.transparent),
        canvasColor: AppColors.lightBackgroundColor,
        scaffoldBackgroundColor: AppColors.lightBackgroundColor,
        hintColor: AppColors.lightTextColor,
        cardColor: AppColors.lightTertiaryColor,
        primaryColor: const Color(AppColors.primaryColor),
        fontFamily: "Rubik",
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.primarySwatch)
            .copyWith(brightness: Brightness.dark, background: AppColors.darkBackgroundColor, surface: AppColors.darkCardColor, outline: Colors.transparent),
        canvasColor: AppColors.darkBackgroundColor,
        primaryColor: const Color(AppColors.primaryColor),
        scaffoldBackgroundColor: AppColors.darkBackgroundColor,
        hintColor: AppColors.darkTextColor,
        cardColor: AppColors.darkTertiaryColor,
        fontFamily: "Rubik",
      ),
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeScreen(),
      builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!),
    );
  }
}
