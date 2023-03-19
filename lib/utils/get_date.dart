String getCurrentDate() {
  DateTime currentDate = DateTime.now();

  String currentWeekday = "";
  String currentMonth = "";

  switch(currentDate.month) {
    case 0: currentMonth = "Января";
    break;
    case 1: currentMonth = "Февраля";
    break;
    case 2: currentMonth = "Марта";
    break;
    case 3: currentMonth = "Апреля";
    break;
    case 4: currentMonth = "Мая";
    break;
    case 5: currentMonth = "Июня";
    break;
    case 6: currentMonth = "Июля";
    break;
    case 7: currentMonth = "Августа";
    break;
    case 8: currentMonth = "Сентября";
    break;
    case 9: currentMonth = "Октября";
    break;
    case 10: currentMonth = "Ноября";
    break;
    case 11: currentMonth = "Декабря";
    break;
  }

  switch(currentDate.weekday) {
    case 1: currentWeekday = "Понедельник";
    break;
    case 2: currentWeekday = "Вторник";
    break;
    case 3: currentWeekday = "Среда";
    break;
    case 4: currentWeekday = "Четверг";
    break;
    case 5: currentWeekday = "Пятница";
    break;
    case 6: currentWeekday = "Суббота";
    break;
    case 7: currentWeekday = "Воскресенье";
    break;
  }

  String dateText = "$currentWeekday, ${currentDate.day} $currentMonth";

  return dateText;
}

int getMonthLeft(int days) {
  List<int> monthCountDays = <int>[
    31, 28,	31,	30,	31,	30,	31,	31,	30,	31,	30,	31
  ];

  int daysLeft = days;
  int monthsLeft = 0;

  while
}