import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/event_category.dart';
import 'package:todo_app/ui/colors.dart';
import 'package:todo_app/ui/icons.dart';
import 'package:todo_app/ui/shapes.dart';
import 'package:todo_app/ui/widgets/color_circle.dart';
import 'package:todo_app/ui/widgets/app_text_field.dart';
import 'package:todo_app/ui/widgets/icon_circle.dart';

import '../../viewmodel/home_viewmodel.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final ScrollController colorController = ScrollController();
  final ScrollController iconController = ScrollController();

  @override
  void initState() {
    super.initState();

    viewModel = Provider.of<HomeViewModel>(context, listen: false);
  }

  late String _eventTitle = "";
  String? _titleError;

  late Color _selectedColor = AppColors().categoryColors[0];
  late int _selectedIcon = 0;

  void _saveCategory() {
    if (_eventTitle.trim().isEmpty) {
      setState(() {
        _titleError = AppLocalizations.of(context).empty_error;
      });
    }

    if (_titleError == null) {
      widget.onCategoryCreate(EventCategory(
        categoryIconID: _selectedIcon,
        categoryColor: _selectedColor.value,
        categoryTitle: _eventTitle,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: AppShapes.roundedRectangleShape,
      surfaceTintColor: Theme.of(context).cardColor,
      child: SingleChildScrollView(
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
                        AppLocalizations.of(context).category_creation_title,
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
                    onChanged: (value) {
                      if (_titleError != null) {
                        setState(() {
                          _titleError = null;
                        });
                      }
                      _eventTitle = value;
                    },
                    errorText: _titleError,
                    maxLength: 25,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surface,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).color,
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Scrollbar(
                            controller: colorController,
                            thumbVisibility: true,
                            child: Container(
                                padding: const EdgeInsets.all(6),
                                constraints: const BoxConstraints(maxHeight: 130),
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    controller: colorController,
                                    physics: const BouncingScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 68),
                                    scrollDirection: Axis.vertical,
                                    itemCount: AppColors().categoryColors.length,
                                    itemBuilder: (rowContext, index) {
                                      Color color = AppColors().categoryColors[index];
                                      return ColorCircle(
                                          color: color,
                                          isSelected: color == _selectedColor,
                                          onSelect: (c) {
                                            setState(() {
                                              _selectedColor = c;
                                            });
                                          });
                                    })),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surface,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).icon,
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Scrollbar(
                              controller: iconController,
                              thumbVisibility: true,
                              child: Container(
                                  padding: const EdgeInsets.all(6),
                                  constraints: const BoxConstraints(maxHeight: 128),
                                  child: GridView.builder(
                                      shrinkWrap: true,
                                      controller: iconController,
                                      physics: const BouncingScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 68),
                                      scrollDirection: Axis.vertical,
                                      itemCount: AppIcons().iconsList.length,
                                      itemBuilder: (rowContext, index) {
                                        return IconCircle(
                                          iconID: index,
                                          isSelected: _selectedIcon == index,
                                          onSelect: (id) {
                                            setState(() {
                                              _selectedIcon = id;
                                            });
                                          },
                                          selectedColor: _selectedColor,
                                        );
                                      }))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        elevation: 0,
                        onPressed: _saveCategory,
                        tooltip: AppLocalizations.of(context).category_add,
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
      ),
    );
  }
}
