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

  int years = duration.inDays ~/ 365;
  int months = (duration.inDays % 365) ~/ 30;
  int days = duration.inDays % 30;
  int hours = duration.inHours % 24;
  int minutes = duration.inMinutes % 60;
  int seconds = duration.inSeconds % 60;

  remainingTime['years'] = years;
  remainingTime['months'] = months;
  remainingTime['days'] = days;
  remainingTime['hours'] = hours;
  remainingTime['minutes'] = minutes;
  remainingTime['seconds'] = seconds;

  return remainingTime;
}