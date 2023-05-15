import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/event_category.dart';
import '../../viewmodel/home_viewmodel.dart';
import '../colors.dart';
import '../icons.dart';
import '../shapes.dart';
import 'app_alert_dialog.dart';
import 'app_button.dart';
import 'app_dropdown.dart';
import 'app_text_field.dart';
import 'color_circle.dart';
import 'icon_circle.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingCategoryDialog extends StatefulWidget {
  final Function() onCloseClick;
  final Function(EventCategory, int) onCategoryChange;

  const SettingCategoryDialog({
    super.key,
    required this.onCloseClick,
    required this.onCategoryChange,
  });

  @override
  State<StatefulWidget> createState() => SettingCategoryDialogState();
}

class SettingCategoryDialogState extends State<SettingCategoryDialog> {
  late HomeViewModel viewModel;

  final ScrollController colorController = ScrollController();
  final ScrollController iconController = ScrollController();

  late EventCategory _category = viewModel.categoryList[0];

  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    viewModel = Provider.of<HomeViewModel>(context, listen: false);
    _titleController.text = _category.categoryTitle;

    _selectedIcon = _category.categoryIconID;
    _selectedColor = Color(_category.categoryColor);
  }

  late String _categoryTitle = _category.categoryTitle;
  String? _titleError;

  late Color _selectedColor = AppColors().categoryColors[0];
  late int _selectedIcon = 0;

  void _saveCategory() {
    if (_categoryTitle.trim().isEmpty) {
      setState(() {
        _titleError = AppLocalizations.of(context).empty_error;
      });
    }

    if (_titleError == null) {
      widget.onCategoryChange(
          EventCategory(
            categoryIconID: _selectedIcon,
            categoryColor: _selectedColor.value,
            categoryTitle: _categoryTitle,
          ),
          viewModel.categoryList.indexOf(_category));
    }
  }

  Future<bool?> confirmRemove() async {
    bool result = false;
    await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AppAlertDialog(
              title: AppLocalizations.of(context).delete_category_title,
              description: AppLocalizations.of(context).delete_category_description,
              confirmTitle: AppLocalizations.of(context).dialog_confirm,
              onConfirmPressed: () {
                Navigator.pop(context);
                result = true;
              },
              dismissTitle: AppLocalizations.of(context).dialog_cancel,
              onDismissPressed: () {
                Navigator.pop(context);
                result = false;
              });
        });
    return result;
  }

  void _removeCategory() async {
    bool? result = await confirmRemove();

    if (result == true) {
      Navigator.pop(context);
      await viewModel.removeCategory(_category);
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
                        AppLocalizations.of(context).category_manage_title,
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
                  CategoryDropdown(
                      value: _category,
                      items: viewModel.categoryList,
                      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                      onChanged: (eventCategory) {
                        setState(() {
                          _category = eventCategory;
                          _titleController.text = _category.categoryTitle;
                          _categoryTitle = _category.categoryTitle;
                          _selectedIcon = _category.categoryIconID;
                          _selectedColor = Color(_category.categoryColor);
                        });
                      }),
                  const SizedBox(height: 8),
                  AppTextField(
                    hint: AppLocalizations.of(context).name,
                    controller: _titleController,
                    margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                    onChanged: (value) {
                      if (_titleError != null) {
                        setState(() {
                          _titleError = null;
                        });
                      }
                      _categoryTitle = value;
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
                            radius: const Radius.circular(100),
                            child: Container(
                                padding: const EdgeInsets.all(6),
                                constraints: const BoxConstraints(maxHeight: 130),
                                child: GridView.builder(
                                  controller: colorController,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 68),
                                  scrollDirection: Axis.vertical,
                                  itemCount: AppColors().categoryColors.length,
                                  itemBuilder: (rowContext, index) {
                                    Color color = AppColors().categoryColors[index];
                                    return ColorCircle(
                                        color: color,
                                        isSelected: color.value == _selectedColor.value,
                                        onSelect: (c) {
                                          setState(() {
                                            _selectedColor = c;
                                          });
                                        });
                                  },
                                )),
                          )
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
                            radius: const Radius.circular(100),
                            child: Container(
                                padding: const EdgeInsets.all(6),
                                constraints: const BoxConstraints(maxHeight: 128),
                                child: GridView.builder(
                                  controller: iconController,
                                  shrinkWrap: true,
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
                                  },
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      viewModel.categoryList.length > 1
                          ? AppTextButton(
                              label: AppLocalizations.of(context).delete,
                              onPressed: _removeCategory,
                              splashColor: Theme.of(context).errorColor.withOpacity(0.2),
                              hoverColor: Theme.of(context).errorColor.withOpacity(0.1),
                              textStyle: TextStyle(color: Theme.of(context).errorColor),
                            )
                          : const SizedBox(),
                      FloatingActionButton(
                        elevation: 0,
                        onPressed: _saveCategory,
                        tooltip: AppLocalizations.of(context).category_save,
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
