import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getCurrentDate(BuildContext context) {
  DateTime currentDate = DateTime.now();

  String currentWeekday = "";
  String currentMonth = "";

  switch(currentDate.month) {
    case 1: currentMonth = AppLocalizations.of(context).january;
    break;
    case 2: currentMonth = AppLocalizations.of(context).february;
    break;
    case 3: currentMonth = AppLocalizations.of(context).march;
    break;
    case 4: currentMonth = AppLocalizations.of(context).april;
    break;
    case 5: currentMonth = AppLocalizations.of(context).may;
    break;
    case 6: currentMonth = AppLocalizations.of(context).june;
    break;
    case 7: currentMonth = AppLocalizations.of(context).july;
    break;
    case 8: currentMonth = AppLocalizations.of(context).august;
    break;
    case 9: currentMonth = AppLocalizations.of(context).september;
    break;
    case 10: currentMonth = AppLocalizations.of(context).october;
    break;
    case 11: currentMonth = AppLocalizations.of(context).november;
    break;
    case 12: currentMonth = AppLocalizations.of(context).december;
    break;
  }

  switch(currentDate.weekday) {
    case 1: currentWeekday = AppLocalizations.of(context).monday;
    break;
    case 2: currentWeekday = AppLocalizations.of(context).tuesday;
    break;
    case 3: currentWeekday = AppLocalizations.of(context).wednesday;
    break;
    case 4: currentWeekday = AppLocalizations.of(context).thursday;
    break;
    case 5: currentWeekday = AppLocalizations.of(context).friday;
    break;
    case 6: currentWeekday = AppLocalizations.of(context).saturday;
    break;
    case 7: currentWeekday = AppLocalizations.of(context).sunday;
    break;
  }

  String dateText = "$currentWeekday, ${currentDate.day} $currentMonth";

  return dateText;
}

Map<String, int> calculateRemainingTime(DateTime targetDate) {
  DateTime now = DateTime.now();

  Map<String, int> remainingTime = {};
  Duration duration = targetDate.difference(now);

  // int years = duration.inDays ~/ 365;
  // int months = (duration.inDays % 365) ~/ 30;
  // int days = (duration.inDays % 365) % 30;

  num years = Jiffy(targetDate).diff(now, Units.YEAR);
  num months = Jiffy(targetDate).diff(now, Units.MONTH) % 12;
  num days = 0;
  num hours = Jiffy(targetDate).diff(now, Units.HOUR) % 24;
  num minutes = Jiffy(targetDate).diff(now, Units.MINUTE) % 60;
  num seconds = Jiffy(targetDate).diff(now, Units.SECOND) % 60;

  List<int> daysCount = <int>[
    31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
  ];

  if (months >= 1) {
    days = Jiffy(targetDate).diff(now, Units.DAY);

    if (days > 30) {
      days %= 30;

      if (days == 0) {
        months += 1;
      }
    }

    int currentMonth = now.month;
    for (int i = 1; i <= months; i++) {
      if (daysCount[currentMonth - 1] > 30) {
        days -= 1;
      } else if (daysCount[currentMonth - 1] < 30) {
        if (targetDate.year % 4 == 0) {
          days += 0;
        } else {
          days += 2;
        }
      }

      if (currentMonth == 12) {
        currentMonth = 1;
      }
      currentMonth++;
    }
  } else {
    days = Jiffy(targetDate).diff(now, Units.DAY);
  }


  remainingTime['years'] = years.toInt();
  remainingTime['months'] = months.toInt();
  remainingTime['days'] = days.toInt();
  remainingTime['hours'] = hours.toInt();
  remainingTime['minutes'] = minutes.toInt();
  remainingTime['seconds'] = seconds.toInt();

  return remainingTime;
}