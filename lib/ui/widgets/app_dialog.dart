import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/app_event.dart';
import 'package:todo_app/model/event_category.dart';
import 'package:todo_app/ui/colors.dart';
import 'package:todo_app/ui/shapes.dart';
import 'package:todo_app/ui/widgets/color_circle.dart';
import 'package:todo_app/ui/widgets/app_dropdown.dart';
import 'package:todo_app/ui/widgets/app_text_field.dart';
import 'package:todo_app/viewmodel/home_viewmodel.dart';

class AppDialog extends StatefulWidget {
  final Function() onCloseClick;
  final Function(AppEvent) onEventCreate;

  const AppDialog({
    super.key,
    required this.onCloseClick,
    required this.onEventCreate,
  });

  @override
  State<StatefulWidget> createState() => AppDialogState();
}

class AppDialogState extends State<AppDialog> {
  late HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = Provider.of<HomeViewModel>(context, listen: false);
  }

  final List<String> _repeatList = <String>[
    "Не повторять",
    "Повторять каждый день",
    "Повторять каждую неделю",
    "Повторять каждый месяц",
    "Повторять каждый год"
  ];

  late EventCategory _category = viewModel.categoryList[0];
  late String _eventTitle = "";
  late String _selectedRepeat = _repeatList[0];
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  String? _titleError;
  String? _dateError;

  final TextEditingController _dateTimeController = TextEditingController();

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

  bool _allDayChecked = false;

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
      _selectedDate = picked;

      if (_selectedDate != null) {
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
          _selectedTime = timePicked;

          String month = _selectedDate!.month.toString();
          String day = _selectedDate!.day.toString();

          String hours = _selectedTime!.hour.toString();
          String minutes = _selectedTime!.minute.toString();

          if (_selectedDate!.month < 10) month = "0$month";
          if (_selectedDate!.day < 10) day = "0$day";
          if (_selectedTime!.hour < 10) hours = "0$hours";
          if (_selectedTime!.minute < 10) minutes = "0$minutes";

          setState(() {
            _dateTimeController.text = "$day.$month.${_selectedDate!.year} $hours:$minutes";
          });
        }
      }
    }
  }

  void _saveEvent() {
    if (_eventTitle.trim().isEmpty) {
      setState(() {
        _titleError = "Поле должно быть заполнено.";
      });
    }

    if (_selectedDate == null || _selectedTime == null) {
      setState(() {
        _dateError = "Выбреите дату.";
      });
    }

    if (_titleError == null && _dateError == null) {
      widget.onEventCreate(
          AppEvent(
              title: _eventTitle,
              eventCategory: _category,
              datetime: DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, _selectedTime!.hour, _selectedTime!.minute).toString(),
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: AppShapes.roundedRectangleShape,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Container(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 10),
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
                  margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                  onChanged: (value) {
                    if (_titleError != null) {
                      setState(() {
                        _titleError = null;
                      });
                    }
                    _eventTitle = value;
                  },
                  errorText: _titleError,
                ),
                const SizedBox(height: 6),
                CategoryDropdown(
                    value: _category,
                    items: viewModel.categoryList,
                    onChanged: (eventCategory) {
                      setState(() {
                        _category = eventCategory;
                      });
                    }
                ),
                const SizedBox(height: 6),
                AppTextField(
                  hint: "Дата начала события",
                  margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                  onChanged: (value) {},
                  icon: Icons.calendar_month_rounded,
                  controller: _dateTimeController,
                  onIconPressed: () {
                    if (_dateError != null) {
                      setState(() {
                        _dateError = null;
                      });
                    }
                    _selectDate(context);
                  },
                  readOnly: true,
                  errorText: _dateError,
                ),
                const SizedBox(height: 6),
                AppDropdown(
                    value: _selectedRepeat,
                    items: _repeatList,
                    onChanged: (value) {
                      setState(() {
                        _selectedRepeat = value;
                      });
                    }
                ),
                //late Color _selectedColor = colors[0];
                //Card(
                //  elevation: 0,
                //  color: Theme.of(context).cardColor,
                //  margin: EdgeInsets.zero,
                //  child: Padding(
                //    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                //    child: Column(
                //      crossAxisAlignment: CrossAxisAlignment.start,
                //      children: [
                //        Text(
                //          "Цвет",
                //          style: TextStyle(
                //              color: Theme.of(context).hintColor
                //          ),
                //        ),
                //        const SizedBox(height: 5),
                //        SizedBox(
                //          height: 33,
                //          child: ListView.builder(
                //              scrollDirection: Axis.horizontal,
                //              itemCount: colors.length,
                //              itemBuilder: (rowContext, index) {
                //                Color color = colors[index];
                //                return ColorCircle(
                //                    color: color,
                //                    isSelected: color == selectedColor,
                //                    onSelect: (c) {
                //                      setState(() {
                //                        selectedColor = c;
                //                      });
                //                    }
                //                );
                //              }
                //          ),
                //        )
                //      ],
                //    ),
                //  ),
                //),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      color: Colors.transparent,
                      elevation: 0,
                      shape: AppShapes.roundedRectangleShape,
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              _allDayChecked = !_allDayChecked;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              children: [ Transform.scale(
                                scale: 1.1,
                                child: Checkbox(
                                  value: _allDayChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      _allDayChecked = value!;
                                    });
                                  },
                                  activeColor: Theme.of(context).colorScheme.primary,
                                  checkColor: Colors.white,
                                  hoverColor: Theme.of(context).colorScheme.primary,
                                  shape: AppShapes.smallRoundedRectangleShape,
                                ),
                              ),
                                const Text(
                                  "Весь день",
                                  style: TextStyle(
                                      fontSize: 14
                                  ),
                                )

                              ],
                            ),
                          )
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: _saveEvent,
                      tooltip: "Добавить событие",
                      heroTag: "fab",
                      child: Icon(Icons.check_rounded),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}