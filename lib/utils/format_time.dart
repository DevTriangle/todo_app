String formatTime(int years, int months, int days, int hours, int minutes, int seconds) {
  List<String> time = [];
  if (years > 0) {
    time.add("$years ${getPluralForm(years, 'год', 'года', 'лет')}");
  }
  if (months > 0) {
    time.add("$months ${getPluralForm(months, 'месяц', 'месяца', 'месяцев')}");
  }
  if (days > 0 && years == 0) {
    time.add("$days ${getPluralForm(days, 'день', 'дня', 'дней')}");
  }
  if (hours > 0 && months == 0) {
    time.add("$hours ${getPluralForm(hours, 'час', 'часа', 'часов')}");
  }
  if (minutes > 0 && days == 0) {
    time.add("$minutes ${getPluralForm(minutes, 'минута', 'минуты', 'минут')}");
  }
  if (seconds > 0 && hours == 0) {
    time.add("$seconds ${getPluralForm(seconds, 'секунда', 'секунды', 'секунд')}");
  }
  return time.join(' ');
}

String getPluralForm(int value, String one, String few, String many) {
  int mod10 = value % 10;
  int mod100 = value % 100;
  if (mod10 == 1 && mod100 != 11) {
    return one;
  } else if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
    return few;
  } else {
    return many;
  }
}