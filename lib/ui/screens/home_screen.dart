import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/ui/widgets/app_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late String _displayDateText = "";

  @override
  void initState() {
    super.initState();

    _displayDateText = _getCurrentDate();
  }

  String _getCurrentDate() {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            tooltip: "Добавить событие",
            child: const Icon(Icons.add_rounded),
            heroTag: "fab",
          ),
          body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "События",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      Text(
                        _displayDateText,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  AppCard(
                      title: "Новый год",
                      destination: DateTime.now(),
                      icon: Icons.celebration_rounded,
                      color: Colors.amber
                  ),
                  AppCard(
                      title: "День рождения",
                      destination: DateTime.now(),
                      icon: Icons.cake_rounded,
                      color: Colors.deepOrange
                  ),
                  AppCard(
                      title: "Дата с длинным названием (ооооочень длинным)",
                      destination: DateTime.now(),
                      icon: Icons.menu,
                      color: Colors.greenAccent
                  ),
                  AppCard(
                      title: "Дата",
                      destination: DateTime.now(),
                      icon: Icons.access_time_rounded,
                      color: Colors.pink
                  )
                ],
              )
          )
        )
    );
  }
}