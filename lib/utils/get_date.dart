import 'package:jiffy/jiffy.dart';

String getCurrentDate() {
  DateTime currentDate = DateTime.now();

  String currentWeekday = "";
  String currentMonth = "";

  switch(currentDate.month) {
    case 1: currentMonth = "Января";
    break;
    case 2: currentMonth = "Февраля";
    break;
    case 3: currentMonth = "Марта";
    break;
    case 4: currentMonth = "Апреля";
    break;
    case 5: currentMonth = "Мая";
    break;
    case 6: currentMonth = "Июня";
    break;
    case 7: currentMonth = "Июля";
    break;
    case 8: currentMonth = "Августа";
    break;
    case 9: currentMonth = "Сентября";
    break;
    case 10: currentMonth = "Октября";
    break;
    case 11: currentMonth = "Ноября";
    break;
    case 12: currentMonth = "Декабря";
    break;
  }

  switch(currentDate.weekday) {
    case 1: currentWeekday = "Пн";
    break;
    case 2: currentWeekday = "Вт";
    break;
    case 3: currentWeekday = "Ср";
    break;
    case 4: currentWeekday = "Чт";
    break;
    case 5: currentWeekday = "Пт";
    break;
    case 6: currentWeekday = "Сб";
    break;
    case 7: currentWeekday = "Вс";
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