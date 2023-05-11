import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String formatTime(int years, int months, int days, int hours, int minutes,
    int seconds, BuildContext context) {
  List<String> time = [];
  if (years > 0) {
    time.add(
        "$years ${getPluralForm(years, AppLocalizations.of(context).years_one, AppLocalizations.of(context).years_few, AppLocalizations.of(context).years_many, context)}");
  }
  if (months > 0) {
    time.add(
        "$months ${getPluralForm(months, AppLocalizations.of(context).months_one, AppLocalizations.of(context).months_few, AppLocalizations.of(context).months_many, context)}");
  }
  if (days > 0 && years == 0) {
    time.add(
        "$days ${getPluralForm(days, AppLocalizations.of(context).days_one, AppLocalizations.of(context).days_few, AppLocalizations.of(context).days_many, context)}");
  }
  if (hours > 0 && (months == 0 && years == 0)) {
    time.add(
        "$hours ${getPluralForm(hours, AppLocalizations.of(context).hours_one, AppLocalizations.of(context).hours_few, AppLocalizations.of(context).hours_many, context)}");
  }
  if (((minutes > 0 && (days == 0 && hours == 0)) ||
          (minutes > 0 && (days != 0 && hours == 0))) &&
      months == 0 &&
      years == 0) {
    time.add(
        "$minutes ${getPluralForm(minutes, AppLocalizations.of(context).minutes_one, AppLocalizations.of(context).minutes_few, AppLocalizations.of(context).minutes_many, context)}");
  }
  if (seconds > 0 && hours == 0 && days == 0) {
    time.add(
        "$seconds ${getPluralForm(seconds, AppLocalizations.of(context).seconds_one, AppLocalizations.of(context).seconds_few, AppLocalizations.of(context).seconds_many, context)}");
  }
  return time.join(' ');
}

String getPluralForm(
    int value, String one, String few, String many, BuildContext context) {
  int mod10 = value % 10;
  int mod100 = value % 100;

  if (AppLocalizations.of(context).localeName == "ru") {
    if (mod10 == 1 && mod100 != 11) {
      return one;
    } else if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
      return few;
    } else {
      return many;
    }
  } else {
    if (value == 1) {
      return one;
    } else {
      return many;
    }
  }
}
