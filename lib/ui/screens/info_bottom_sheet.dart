import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/app_event.dart';
import 'package:todo_app/ui/icons.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/ui/shapes.dart';
import 'package:todo_app/ui/widgets/app_button.dart';
import 'package:todo_app/ui/widgets/app_text_field.dart';

class InfoBottomSheet extends StatefulWidget {
  final AppEvent event;
  final Function() onEditPressed;
  final Function(String) onSavePressed;

  const InfoBottomSheet({super.key, required this.event, required this.onEditPressed, required this.onSavePressed});

  @override
  State<StatefulWidget> createState() => InfoBottomSheetState();
}

class InfoBottomSheetState extends State<InfoBottomSheet> {
  String _eventDescription = "";
  DateFormat date = DateFormat("dd.MM.yyyy HH:mm");
  final TextEditingController _descriptionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if (widget.event.description != null) {
      _eventDescription = widget.event.description!;
      _descriptionController.text = _eventDescription;
    }
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.event.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  SvgPicture.asset(
                    AppIcons().iconsList[widget.event.eventCategory.categoryIconID],
                    color: Color(widget.event.eventCategory.categoryColor),
                    width: 14.0,
                    height: 14.0,
                  ),
                  const SizedBox(width: 6),
                  Text(widget.event.eventCategory.categoryTitle,
                      style: TextStyle(
                        color: Color(widget.event.eventCategory.categoryColor),
                        fontWeight: FontWeight.w500,
                      ))
                ],
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "Дата начала: ", style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).hintColor.withOpacity(0.7))),
                    TextSpan(
                      text: date.format(DateTime.parse(widget.event.datetime)),
                      style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Заметка",
                style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: 1),
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: AppShapes.roundedRectangleShape,
                clipBehavior: Clip.antiAlias,
                child: Container(
                    constraints: BoxConstraints(maxHeight: 200),
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      radius: const Radius.circular(100),
                      child: AppTextField(
                        scrollController: _scrollController,
                        hint: "",
                        onChanged: (text) {
                          _eventDescription = text;
                        },
                        margin: EdgeInsets.zero,
                        controller: _descriptionController,
                        maxLength: 4000,
                        maxLines: double.maxFinite.toInt(),
                        minLines: 1,
                        inputType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                      ),
                    )),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: AppButton(text: "Редактировать", onPressed: widget.onEditPressed),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: AppButton(
                      text: "Сохранить",
                      onPressed: () {
                        widget.onSavePressed(_eventDescription.trim());
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
