import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/repeat.dart';

import '../../model/app_event.dart';
import '../../model/event_category.dart';
import '../../utils/notification_service.dart';
import '../../viewmodel/home_viewmodel.dart';
import '../colors.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../shapes.dart';
import '../widgets/app_button.dart';
import '../widgets/app_dropdown.dart';
import '../widgets/app_text_field.dart';
import '../widgets/bottom_sheet_button.dart';
import '../widgets/bottom_sheet_card.dart';
import '../widgets/bottom_sheet_checkbox.dart';

class ManageEventBottomSheet extends StatefulWidget {
  final AppEvent? event;
  final int categoryIndex;
  final Function() onCloseClick;
  final Function(AppEvent) onEventCreate;
  final Function() onRemoveClick;
  final bool isEditing;

  const ManageEventBottomSheet({
    super.key,
    this.event,
    required this.categoryIndex,
    required this.onCloseClick,
    required this.onEventCreate,
    required this.onRemoveClick,
    required this.isEditing,
  });

  @override
  State<StatefulWidget> createState() => ManageEventBottomSheetState();
}

class ManageEventBottomSheetState extends State<ManageEventBottomSheet> {
  late HomeViewModel viewModel;

  bool _fiveChecked = false;
  bool _tenChecked = false;
  bool _fifteenChecked = false;
  bool _thirtyChecked = false;
  bool _hourChecked = false;
  bool _fourHChecked = false;
  bool _dayChecked = false;
  int _selectedCount = 0;

  bool _disableNotification = false;

  DateFormat date = DateFormat("dd.MM.yyyy HH:mm");
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;

  late Repeat _selectedRepeat = viewModel.repeatList[0];

  late EventCategory _category = viewModel.categoryList[0];
  late String _eventTitle = "";
  String? _eventDescription;

  @override
  void initState() {
    super.initState();

    viewModel = Provider.of<HomeViewModel>(context, listen: false);

    if (widget.isEditing) {
      DateTime time = DateTime.parse(widget.event!.datetime);
      _eventTitle = widget.event!.title;
      _titleController.text = widget.event!.title;
      _dateTimeController.text = date.format(time);

      _selectedRepeat = widget.event!.repeat;

      _category = viewModel.categoryList[widget.categoryIndex];

      _selectedDate = time;
      _selectedTime = TimeOfDay(hour: time.hour, minute: time.minute);

      _fiveChecked = widget.event!.reminders.any((element) => element == "5m");
      if (_fiveChecked) {
        _selectedCount++;
      }
      _tenChecked = widget.event!.reminders.any((element) => element == "10m");
      if (_tenChecked) {
        _selectedCount++;
      }
      _fifteenChecked = widget.event!.reminders.any((element) => element == "15m");
      if (_fifteenChecked) {
        _selectedCount++;
      }
      _thirtyChecked = widget.event!.reminders.any((element) => element == "30m");
      if (_thirtyChecked) {
        _selectedCount++;
      }
      _hourChecked = widget.event!.reminders.any((element) => element == "1h");
      if (_hourChecked) {
        _selectedCount++;
      }
      _fourHChecked = widget.event!.reminders.any((element) => element == "4h");
      if (_fourHChecked) {
        _selectedCount++;
      }
      _dayChecked = widget.event!.reminders.any((element) => element == "1d");
      if (_dayChecked) {
        _selectedCount++;
      }
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

  void _saveEvent() async {
    DateTime dateTime = DateTime.now();

    if (_eventTitle.trim().isEmpty) {
      setState(() {
        _titleError = AppLocalizations.of(context).empty_error;
      });
    }

    if (_selectedTime == null) {
      setState(() {
        _dateError = AppLocalizations.of(context).empty_date_error;
      });
    } else {
      dateTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTime!.hour, _selectedTime!.minute);

      if (dateTime.isBefore(DateTime.now())) {
        setState(() {
          _dateError = "Дата должна быть больше текущей";
        });
      }
    }

    if (widget.isEditing) {
      for (var n in widget.event!.notifications) {
        await NotificationService().cancelNotification(n.id);
      }
    }

    List<AppNotification> notifications = [];
    if (!_disableNotification) {
      notifications = await viewModel.scheduleNotifications(
        _eventTitle,
        dateTime,
        _selectedRepeat,
        _fiveChecked,
        _tenChecked,
        _fifteenChecked,
        _thirtyChecked,
        _hourChecked,
        _fourHChecked,
        _dayChecked,
      );
    }

    List<String> reminders = [];
    if (_fiveChecked) {
      reminders.add("5m");
    }
    if (_tenChecked) {
      reminders.add("10m");
    }
    if (_fifteenChecked) {
      reminders.add("15m");
    }
    if (_thirtyChecked) {
      reminders.add("30m");
    }
    if (_hourChecked) {
      reminders.add("1h");
    }
    if (_fourHChecked) {
      reminders.add("4h");
    }
    if (_dayChecked) {
      reminders.add("1d");
    }

    if (!widget.isEditing) {
      if (_titleError == null && _dateError == null) {
        widget.onEventCreate(AppEvent(
          id: Random().nextInt(2147483647),
          description: _eventDescription,
          title: _eventTitle,
          eventCategory: _category,
          datetime: dateTime.toString(),
          disableNotifications: _disableNotification,
          notifications: notifications,
          reminders: reminders,
          repeat: _selectedRepeat,
        ));
      }
    } else {
      widget.onEventCreate(
        AppEvent(
          id: widget.event!.id,
          description: _eventDescription,
          title: _eventTitle,
          eventCategory: _category,
          datetime: dateTime.toString(),
          disableNotifications: _disableNotification,
          notifications: notifications,
          reminders: reminders,
          repeat: _selectedRepeat,
        ),
      );
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

      _selectedCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 20,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: [
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
                                                      inactiveThumbColor: Theme.of(context).hintColor,
                                                      inactiveTrackColor: Theme.of(context).hintColor.withOpacity(0.15),
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
                                            enabled: (!_disableNotification && _selectedCount < 3) || _fiveChecked,
                                            onPressed: (value) {
                                              setState(() {
                                                _fiveChecked = value!;

                                                if (value) {
                                                  _selectedCount++;
                                                } else {
                                                  _selectedCount--;
                                                }
                                              });

                                              setSheetState(() {});
                                            },
                                          ),
                                          BottomSheetCheckbox(
                                            label: AppLocalizations.of(context).t10min,
                                            checked: _tenChecked,
                                            enabled: (!_disableNotification && _selectedCount < 3) || _tenChecked,
                                            onPressed: (value) {
                                              setState(() {
                                                _tenChecked = value!;

                                                if (value) {
                                                  _selectedCount++;
                                                } else {
                                                  _selectedCount--;
                                                }
                                              });

                                              setSheetState(() {});
                                            },
                                          ),
                                          BottomSheetCheckbox(
                                            label: AppLocalizations.of(context).t15min,
                                            checked: _fifteenChecked,
                                            enabled: (!_disableNotification && _selectedCount < 3) || _fifteenChecked,
                                            onPressed: (value) {
                                              setState(() {
                                                _fifteenChecked = value!;

                                                if (value) {
                                                  _selectedCount++;
                                                } else {
                                                  _selectedCount--;
                                                }
                                              });

                                              setSheetState(() {});
                                            },
                                          ),
                                          BottomSheetCheckbox(
                                            label: AppLocalizations.of(context).t30min,
                                            checked: _thirtyChecked,
                                            enabled: (!_disableNotification && _selectedCount < 3) || _thirtyChecked,
                                            onPressed: (value) {
                                              setState(() {
                                                _thirtyChecked = value!;

                                                if (value) {
                                                  _selectedCount++;
                                                } else {
                                                  _selectedCount--;
                                                }
                                              });

                                              setSheetState(() {});
                                            },
                                          ),
                                          BottomSheetCheckbox(
                                            label: AppLocalizations.of(context).t1hour,
                                            checked: _hourChecked,
                                            enabled: (!_disableNotification && _selectedCount < 3) || _hourChecked,
                                            onPressed: (value) {
                                              setState(() {
                                                _hourChecked = value!;

                                                if (value) {
                                                  _selectedCount++;
                                                } else {
                                                  _selectedCount--;
                                                }
                                              });

                                              setSheetState(() {});
                                            },
                                          ),
                                          BottomSheetCheckbox(
                                            label: AppLocalizations.of(context).t4hours,
                                            checked: _fourHChecked,
                                            enabled: (!_disableNotification && _selectedCount < 3) || _fourHChecked,
                                            onPressed: (value) {
                                              setState(() {
                                                _fourHChecked = value!;

                                                if (value) {
                                                  _selectedCount++;
                                                } else {
                                                  _selectedCount--;
                                                }
                                              });

                                              setSheetState(() {});
                                            },
                                          ),
                                          BottomSheetCheckbox(
                                            label: AppLocalizations.of(context).t1day,
                                            checked: _dayChecked,
                                            enabled: (!_disableNotification && _selectedCount < 3) || _dayChecked,
                                            onPressed: (value) {
                                              setState(() {
                                                _dayChecked = value!;

                                                if (value) {
                                                  _selectedCount++;
                                                } else {
                                                  _selectedCount--;
                                                }
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
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            AppLocalizations.of(context).reminders,
                            style: TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              RepeatDropdown(
                  value: _selectedRepeat,
                  items: viewModel.repeatList,
                  onChanged: (repeat) {
                    setState(() {
                      _selectedRepeat = repeat;
                    });
                  }),
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
          ),
        )
      ],
    );
  }
}
