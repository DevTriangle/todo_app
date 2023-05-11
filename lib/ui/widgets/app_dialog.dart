import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/app_event.dart';
import 'package:todo_app/model/event_category.dart';
import 'package:todo_app/ui/colors.dart';
import 'package:todo_app/ui/shapes.dart';
import 'package:todo_app/ui/widgets/app_dropdown.dart';
import 'package:todo_app/ui/widgets/app_text_field.dart';
import 'package:todo_app/viewmodel/home_viewmodel.dart';

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

  const AppDialog(
      {super.key,
      this.title = "",
      required this.destination,
      required this.categoryIndex,
      required this.onCloseClick,
      required this.onEventCreate,
      required this.onRemoveClick,
      required this.isEditing});

  @override
  State<StatefulWidget> createState() => AppDialogState();
}

class AppDialogState extends State<AppDialog> {
  late HomeViewModel viewModel;

  DateFormat date = DateFormat("dd.MM.yyyy HH:mm");
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;

  late EventCategory _category = viewModel.categoryList[0];
  late String _eventTitle = "";

  @override
  void initState() {
    super.initState();

    viewModel = Provider.of<HomeViewModel>(context, listen: false);

    _eventTitle = widget.title;
    _titleController.text = widget.title;
    _dateTimeController.text = date.format(widget.destination);

    _category = viewModel.categoryList[widget.categoryIndex];

    _selectedDate = widget.destination;
    _selectedTime = TimeOfDay(
        hour: widget.destination.hour, minute: widget.destination.minute);
  }

  String? _titleError;
  String? _dateError;

  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      locale: const Locale("ru", "RU"),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 1000)),
      builder: (BuildContext mContext, Widget? child) {
        return Theme(
          data: ThemeData.from(
                  colorScheme: Theme.of(context).colorScheme,
                  useMaterial3: true)
              .copyWith(
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

      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext mContext, Widget? child) {
          return Theme(
            data: ThemeData.from(
                    colorScheme: Theme.of(context).colorScheme,
                    useMaterial3: true)
                .copyWith(
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
          _dateTimeController.text =
              "$day.$month.${_selectedDate.year} $hours:$minutes";
        });
      }
    }
  }

  void _saveEvent() {
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

    if (_titleError == null && _dateError == null) {
      widget.onEventCreate(AppEvent(
        title: _eventTitle,
        eventCategory: _category,
        datetime: DateTime(_selectedDate.year, _selectedDate.month,
                _selectedDate.day, _selectedTime!.hour, _selectedTime!.minute)
            .toString(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: AppShapes.roundedRectangleShape,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Container(
        padding:
            const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 10),
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.isEditing
                          ? AppLocalizations.of(context).event_manage_title
                          : AppLocalizations.of(context).event_creation_title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).hintColor),
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
                            color:
                                Theme.of(context).hintColor.withOpacity(0.65),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 13),
                AppTextField(
                  hint: AppLocalizations.of(context).name,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
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
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.isEditing
                        ? AppTextButton(
                            label: AppLocalizations.of(context).delete,
                            onPressed: widget.onRemoveClick,
                            splashColor:
                                Theme.of(context).errorColor.withOpacity(0.2),
                            hoverColor:
                                Theme.of(context).errorColor.withOpacity(0.1),
                            textStyle:
                                TextStyle(color: Theme.of(context).errorColor),
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
