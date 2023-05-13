import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/app_event.dart';
import 'package:todo_app/model/event_category.dart';
import 'package:todo_app/ui/colors.dart';
import 'package:todo_app/ui/shapes.dart';
import 'package:todo_app/ui/widgets/app_dropdown.dart';
import 'package:todo_app/ui/widgets/app_text_field.dart';
import 'package:todo_app/ui/widgets/bottom_sheet_button.dart';
import 'package:todo_app/ui/widgets/bottom_sheet_card.dart';
import 'package:todo_app/ui/widgets/bottom_sheet_checkbox.dart';
import 'package:todo_app/viewmodel/home_viewmodel.dart';
import 'package:uuid/uuid.dart';

import '../../utils/notification_service.dart';
import 'app_button.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppDialog extends StatefulWidget {
  final String title;
  final DateTime destination;
  final int categoryIndex;
  final Function() onCloseClick;
  final Function(AppEvent) onEventCreate;
  final Function() onRemoveClick;
  final bool isEditing;
  final AppEvent? event;

  const AppDialog(
      {super.key,
      this.title = "",
      required this.destination,
      required this.categoryIndex,
      required this.onCloseClick,
      required this.onEventCreate,
      required this.onRemoveClick,
      required this.isEditing,
      this.event});

  @override
  State<StatefulWidget> createState() => AppDialogState();
}

class AppDialogState extends State<AppDialog> {
  late HomeViewModel viewModel;

  bool _fiveChecked = false;
  bool _tenChecked = false;
  bool _fifteenChecked = false;
  bool _thirtyChecked = false;
  bool _hourChecked = false;
  bool _fourHChecked = false;
  bool _dayChecked = false;

  bool _disableNotification = false;

  DateFormat date = DateFormat("dd.MM.yyyy HH:mm");
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;

  late EventCategory _category = viewModel.categoryList[0];
  late String _eventTitle = "";
  String? _eventDescription;

  @override
  void initState() {
    super.initState();

    viewModel = Provider.of<HomeViewModel>(context, listen: false);

    _eventTitle = widget.title;
    _titleController.text = widget.title;
    _dateTimeController.text = date.format(widget.destination);

    _category = viewModel.categoryList[widget.categoryIndex];

    _selectedDate = widget.destination;
    _selectedTime = TimeOfDay(hour: widget.destination.hour, minute: widget.destination.minute);

    if (widget.isEditing) {
      _fiveChecked = widget.event!.notifications.any((element) => element.time == "5m");
      _tenChecked = widget.event!.notifications.any((element) => element.time == "10m");
      _fifteenChecked = widget.event!.notifications.any((element) => element.time == "15m");
      _thirtyChecked = widget.event!.notifications.any((element) => element.time == "30m");
      _hourChecked = widget.event!.notifications.any((element) => element.time == "1h");
      _fourHChecked = widget.event!.notifications.any((element) => element.time == "4h");
      _dayChecked = widget.event!.notifications.any((element) => element.time == "1d");
    }
  }

  String? _titleError;
  String? _dateError;

  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      locale: Locale(AppLocalizations.of(context).localeName),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 1000)),
      builder: (BuildContext mContext, Widget? child) {
        return Theme(
          data: ThemeData.from(colorScheme: Theme.of(context).colorScheme, useMaterial3: true).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                surface: AppColors.primarySwatch.shade900,
                onSurface: Theme.of(context).hintColor,
                onPrimaryContainer: Theme.of(context).hintColor,
                onSecondaryContainer: Theme.of(context).hintColor,
                onTertiaryContainer: Theme.of(context).hintColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _selectedDate = picked;

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

        String month = _selectedDate.month.toString();
        String day = _selectedDate.day.toString();

        String hours = _selectedTime!.hour.toString();
        String minutes = _selectedTime!.minute.toString();

        if (_selectedDate.month < 10) month = "0$month";
        if (_selectedDate.day < 10) day = "0$day";
        if (_selectedTime!.hour < 10) hours = "0$hours";
        if (_selectedTime!.minute < 10) minutes = "0$minutes";

        setState(() {
          _dateTimeController.text = "$day.$month.${_selectedDate.year} $hours:$minutes";
        });
      }
    }
  }

  void _saveEvent() {
    String uuid = const Uuid().v4();
    DateTime dateTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTime!.hour, _selectedTime!.minute);
    if (_eventTitle.trim().isEmpty) {
      setState(() {
        _titleError = AppLocalizations.of(context).empty_error;
      });
    }

    if (_selectedTime == null) {
      setState(() {
        _dateError = AppLocalizations.of(context).empty_date_error;
      });
    }

    List<AppNotification> notifications = [];

    DateFormat date = DateFormat("dd.MM.yyyy HH:mm");
    if (_fiveChecked) {
      int id = Random().nextInt(2147483647);
      NotificationService().scheduleNotifications(id, _eventTitle, date.format(dateTime), true, dateTime.subtract(const Duration(minutes: 5)), context);
      notifications.add(AppNotification(id, "5m"));
    }

    if (_tenChecked) {
      int id = Random().nextInt(2147483647);
      NotificationService().scheduleNotifications(id, _eventTitle, date.format(dateTime), true, dateTime.subtract(const Duration(minutes: 10)), context);
      notifications.add(AppNotification(id, "10m"));
    }
    if (_fifteenChecked) {
      int id = Random().nextInt(2147483647);
      NotificationService().scheduleNotifications(id, _eventTitle, date.format(dateTime), true, dateTime.subtract(const Duration(minutes: 15)), context);
      notifications.add(AppNotification(id, "15m"));
    }
    if (_thirtyChecked) {
      int id = Random().nextInt(2147483647);
      NotificationService().scheduleNotifications(id, _eventTitle, date.format(dateTime), true, dateTime.subtract(const Duration(minutes: 30)), context);
      notifications.add(AppNotification(id, "30m"));
    }
    if (_hourChecked) {
      int id = Random().nextInt(2147483647);
      NotificationService().scheduleNotifications(id, _eventTitle, date.format(dateTime), true, dateTime.subtract(const Duration(hours: 1)), context);
      notifications.add(AppNotification(id, "1h"));
    }

    if (_fourHChecked) {
      int id = Random().nextInt(2147483647);
      NotificationService().scheduleNotifications(id, _eventTitle, date.format(dateTime), true, dateTime.subtract(const Duration(hours: 4)), context);
      notifications.add(AppNotification(id, "4h"));
    }

    if (_dayChecked) {
      int id = Random().nextInt(2147483647);
      NotificationService().scheduleNotifications(id, _eventTitle, date.format(dateTime), true, dateTime.subtract(const Duration(days: 1)), context);
      notifications.add(AppNotification(id, "1d"));
    }

    if (_titleError == null && _dateError == null) {
      widget.onEventCreate(AppEvent(
          id: Random().nextInt(2147483647),
          description: _eventDescription,
          title: _eventTitle,
          eventCategory: _category,
          datetime: dateTime.toString(),
          disableNotifications: _disableNotification,
          notifications: notifications));
    }
  }

  void _disableNotifications() {
    setState(() {
      _disableNotification = !_disableNotification;
      _fiveChecked = false;
      _tenChecked = false;
      _fifteenChecked = false;
      _thirtyChecked = false;
      _hourChecked = false;
      _fourHChecked = false;
      _dayChecked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: AppShapes.roundedRectangleShape,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
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
                    Text(
                      widget.isEditing ? AppLocalizations.of(context).event_manage_title : AppLocalizations.of(context).event_creation_title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Theme.of(context).hintColor),
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
                  hint: AppLocalizations.of(context).name,
                  margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                  controller: _titleController,
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
                const SizedBox(height: 9),
                CategoryDropdown(
                    value: _category,
                    items: viewModel.categoryList,
                    onChanged: (eventCategory) {
                      setState(() {
                        _category = eventCategory;
                      });
                    }),
                const SizedBox(height: 9),
                AppTextField(
                  hint: AppLocalizations.of(context).event_start_date,
                  margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                  onChanged: (value) {},
                  onTap: () {
                    if (_dateError != null) {
                      setState(() {
                        _dateError = null;
                      });
                    }
                    _selectDate(context);
                  },
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
                const SizedBox(height: 9),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          color: Theme.of(context).colorScheme.surface,
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                elevation: 0,
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (builder) {
                                  return Wrap(
                                    children: [
                                      StatefulBuilder(
                                        builder: (b, setSheetState) {
                                          return BottomSheetCard(
                                            label: AppLocalizations.of(context).reminders,
                                            children: [
                                              Card(
                                                elevation: 0,
                                                margin: EdgeInsets.zero,
                                                shape: AppShapes.roundedRectangleShape,
                                                color: Colors.transparent,
                                                clipBehavior: Clip.antiAlias,
                                                child: InkWell(
                                                  onTap: () {
                                                    _disableNotifications();
                                                    setSheetState(() {});
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.notifications_off_rounded,
                                                              color: Theme.of(context).hintColor,
                                                            ),
                                                            const SizedBox(width: 10),
                                                            Text(
                                                              AppLocalizations.of(context).disable_notifications,
                                                              style: TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
                                                            ),
                                                          ],
                                                        ),
                                                        Switch(
                                                          value: _disableNotification,
                                                          activeColor: Theme.of(context).primaryColor,
                                                          inactiveTrackColor: Theme.of(context).hintColor.withOpacity(0.1),
                                                          onChanged: (value) {
                                                            _disableNotifications();
                                                            setSheetState(() {});
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                    color: Theme.of(context).hintColor.withOpacity(0.2),
                                                    height: 0.5,
                                                  )),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              BottomSheetCheckbox(
                                                label: AppLocalizations.of(context).t5min,
                                                checked: _fiveChecked,
                                                enabled: !_disableNotification,
                                                onPressed: (value) {
                                                  setState(() {
                                                    _fiveChecked = value!;
                                                  });

                                                  setSheetState(() {});
                                                },
                                              ),
                                              BottomSheetCheckbox(
                                                label: AppLocalizations.of(context).t10min,
                                                checked: _tenChecked,
                                                enabled: !_disableNotification,
                                                onPressed: (value) {
                                                  setState(() {
                                                    _tenChecked = value!;
                                                  });

                                                  setSheetState(() {});
                                                },
                                              ),
                                              BottomSheetCheckbox(
                                                label: AppLocalizations.of(context).t15min,
                                                checked: _fifteenChecked,
                                                enabled: !_disableNotification,
                                                onPressed: (value) {
                                                  setState(() {
                                                    _fifteenChecked = value!;
                                                  });

                                                  setSheetState(() {});
                                                },
                                              ),
                                              BottomSheetCheckbox(
                                                label: AppLocalizations.of(context).t30min,
                                                checked: _thirtyChecked,
                                                enabled: !_disableNotification,
                                                onPressed: (value) {
                                                  setState(() {
                                                    _thirtyChecked = value!;
                                                  });

                                                  setSheetState(() {});
                                                },
                                              ),
                                              BottomSheetCheckbox(
                                                label: AppLocalizations.of(context).t1hour,
                                                checked: _hourChecked,
                                                enabled: !_disableNotification,
                                                onPressed: (value) {
                                                  setState(() {
                                                    _hourChecked = value!;
                                                  });

                                                  setSheetState(() {});
                                                },
                                              ),
                                              BottomSheetCheckbox(
                                                label: AppLocalizations.of(context).t4hours,
                                                checked: _fourHChecked,
                                                enabled: !_disableNotification,
                                                onPressed: (value) {
                                                  setState(() {
                                                    _fourHChecked = value!;
                                                  });

                                                  setSheetState(() {});
                                                },
                                              ),
                                              BottomSheetCheckbox(
                                                label: AppLocalizations.of(context).t1day,
                                                checked: _dayChecked,
                                                enabled: !_disableNotification,
                                                onPressed: (value) {
                                                  setState(() {
                                                    _dayChecked = value!;
                                                  });

                                                  setSheetState(() {});
                                                },
                                              ),
                                              const SizedBox(height: 12),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                    color: Theme.of(context).hintColor.withOpacity(0.2),
                                                    height: 0.5,
                                                  )),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              BottomSheetButton(
                                                icon: Icons.save_rounded,
                                                label: AppLocalizations.of(context).dialog_save,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                AppLocalizations.of(context).reminders,
                                style: TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.isEditing
                        ? AppTextButton(
                            label: AppLocalizations.of(context).delete,
                            onPressed: widget.onRemoveClick,
                            splashColor: Theme.of(context).errorColor.withOpacity(0.2),
                            hoverColor: Theme.of(context).errorColor.withOpacity(0.1),
                            textStyle: TextStyle(color: Theme.of(context).errorColor),
                          )
                        : const SizedBox(),
                    FloatingActionButton(
                      elevation: 0,
                      onPressed: _saveEvent,
                      tooltip: AppLocalizations.of(context).event_add,
                      heroTag: "fab",
                      child: const Icon(Icons.check_rounded),
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
