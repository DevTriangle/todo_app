import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/app_event.dart';
import 'package:todo_app/model/event_category.dart';
import 'package:todo_app/ui/colors.dart';
import 'package:todo_app/ui/icons.dart';
import 'package:todo_app/ui/shapes.dart';
import 'package:todo_app/ui/widgets/color_circle.dart';
import 'package:todo_app/ui/widgets/app_dropdown.dart';
import 'package:todo_app/ui/widgets/app_text_field.dart';
import 'package:todo_app/ui/widgets/icon_circle.dart';

import '../../viewmodel/home_viewmodel.dart';

class AppCategoryDialog extends StatefulWidget {
  final Function() onCloseClick;
  final Function(EventCategory) onCategoryCreate;

  const AppCategoryDialog({
    super.key,
    required this.onCloseClick,
    required this.onCategoryCreate,
  });

  @override
  State<StatefulWidget> createState() => AppCategoryDialogState();
}

class AppCategoryDialogState extends State<AppCategoryDialog> {
  late HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = Provider.of<HomeViewModel>(context, listen: false);
  }

  late String _eventTitle = "";
  String? _titleError;

  List<Color> colors = <Color>[
    Colors.redAccent,
    Colors.pink,
    Colors.amber,
    Colors.blueAccent,
    Colors.purple,
    Colors.indigo,
    Colors.lightGreen,
    Colors.deepOrange,
  ];

  late Color _selectedColor = colors[0];
  late int _selectedIcon = 0;

  void _saveCategory() {
    if (_eventTitle.trim().isEmpty) {
      setState(() {
        _titleError = "Поле должно быть заполнено.";
      });
    }

    if (_titleError == null) {
      widget.onCategoryCreate(
          EventCategory(
            categoryIconID: 2,
            categoryColor: _selectedColor.value,
            categoryTitle: _eventTitle,
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
                      "Создание категории",
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
                SizedBox(height: 6),
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
                                    isSelected: color == _selectedColor,
                                    onSelect: (c) {
                                      setState(() {
                                        _selectedColor = c;
                                      });
                                    }
                                );
                              }
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
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
                          "Иконка",
                          style: TextStyle(
                              color: Theme.of(context).hintColor
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 33,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: AppIcons().iconsList.length,
                              itemBuilder: (rowContext, index) {
                                return IconCircle(
                                    iconID: index,
                                    isSelected: _selectedIcon == index,
                                    onSelect: (id) {
                                      setState(() {
                                        _selectedIcon = id;
                                      });
                                    }
                                );
                              }
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: _saveCategory,
                      tooltip: "Добавить событие",
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