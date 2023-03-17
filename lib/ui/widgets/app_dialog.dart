import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/event_category.dart';
import 'package:todo_app/ui/colors.dart';
import 'package:todo_app/ui/shapes.dart';
import 'package:todo_app/ui/widgets/ColorCircle.dart';
import 'package:todo_app/ui/widgets/app_dropdown.dart';
import 'package:todo_app/ui/widgets/app_text_field.dart';

class AppDialog extends StatefulWidget {
  final Function() onCloseClick;
  final Function onTitleChanged;
  final Function(EventCategory) onCategoryChanged;

  const AppDialog({
    super.key,
    required this.onCloseClick,
    required this.onTitleChanged,
    required this.onCategoryChanged,
  });

  @override
  State<StatefulWidget> createState() => AppDialogState();
}

class AppDialogState extends State<AppDialog> {
  List<EventCategory> categoryList = <EventCategory>[
    EventCategory(categoryTitle: "Праздники", categoryIcon: Icons.celebration_rounded, categoryColor: Colors.amber),
    EventCategory(categoryTitle: "Дни рождения", categoryIcon: Icons.cake_rounded, categoryColor: Colors.redAccent),
    EventCategory(categoryTitle: "Другое", categoryIcon: Icons.more_horiz_rounded, categoryColor: Colors.grey),
  ];

  late EventCategory category = categoryList[0];
  late Color selectedColor = colors[0];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  DateTime _currentTime = DateTime.now();
  TextEditingController dateTimeController = TextEditingController();

  List<Color> colors = <Color>[
    Colors.redAccent,
    Colors.pink,
    Colors.amber,
    Colors.blueAccent,
    Colors.purple,
    Colors.indigo,
    Colors.lightGreen,
    Colors.deepOrange,
    Colors.deepOrange,
    Colors.deepOrange,
    Colors.deepOrange,
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 1000)),
      builder: (BuildContext mContext, Widget? child) {
        return Theme(
          data: ThemeData.from(colorScheme: Theme.of(context).colorScheme, useMaterial3: true).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              surface: AppColors.primarySwatch.shade900,
              onSurface: Theme.of(context).hintColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate = picked;

      if (selectedDate != null) {
        final TimeOfDay? timePicked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext mContext, Widget? child) {
            return Theme(
              data: ThemeData.from(colorScheme: Theme.of(context).colorScheme, useMaterial3: true).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  surface: Theme.of(context).colorScheme.surface,
                  onSurface: Theme.of(context).hintColor,
                ),
              ),
              child: child!,
            );
          },
        );

        if (timePicked != null) {
          selectedTime = timePicked;

          String month = selectedDate.month.toString();
          String day = selectedDate.day.toString();

          String hours = selectedTime.hour.toString();
          String minutes = selectedTime.minute.toString();

          if (selectedDate.month < 10) month = "0$month";
          if (selectedDate.day < 10) day = "0$day";
          if (selectedTime.hour < 10) hours = "0$hours";
          if (selectedTime.minute < 10) minutes = "0$minutes";

          setState(() {
            dateTimeController.text = "$day.$month.${selectedDate.year} $hours:$minutes";
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: AppShapes.roundedRectangleShape,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Создание события",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Card(
                      margin: EdgeInsets.zero,
                      clipBehavior: Clip.antiAlias,
                      color: Colors.transparent,
                      elevation: 0,
                      shape: AppShapes.circleShape,
                      child: InkWell(
                        onTap: widget.onCloseClick,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.close_rounded,
                            color: Theme.of(context).hintColor.withOpacity(0.65),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 13),
                AppTextField(
                    hint: "Название",
                    margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 3),
                    onChanged: widget.onTitleChanged
                ),
                CategoryDropdown(
                    value: category,
                    items: categoryList,
                    onChanged: (eventCategory) {
                      setState(() {
                        widget.onCategoryChanged(eventCategory);
                        category = eventCategory;
                      });
                    }
                ),
                AppTextField(
                  hint: "Дата начала события",
                  margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 3),
                  onChanged: widget.onTitleChanged,
                  icon: Icons.calendar_month_rounded,
                  controller: dateTimeController,
                  onIconPressed: () {
                    _selectDate(context);
                  },
                  readOnly: true,
                ),
                const SizedBox(height: 2.5),
                Card(
                  elevation: 0,
                  color: Theme.of(context).cardColor,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Цвет",
                          style: TextStyle(
                              color: Theme.of(context).hintColor
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 33,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: colors.length,
                              itemBuilder: (rowContext, index) {
                                Color color = colors[index];
                                return ColorCircle(
                                    color: color,
                                    isSelected: color == selectedColor,
                                    onSelect: (c) {
                                      setState(() {
                                        selectedColor = c;
                                      });
                                    }
                                );
                              }
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton.extended(
                      onPressed: () {

                      },
                      tooltip: "Добавить событие",
                      heroTag: "fab",
                      label: Row(
                        children: [
                          const Icon(Icons.add_rounded),
                          SizedBox(width: 5),
                          Text("Добавить событие")
                        ],
                      ),
                      extendedPadding: EdgeInsets.all(10),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    ) ;
  }
}