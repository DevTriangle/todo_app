import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/event_category.dart';
import '../../viewmodel/home_viewmodel.dart';
import '../colors.dart';
import '../icons.dart';
import '../shapes.dart';
import 'app_button.dart';
import 'app_dropdown.dart';
import 'app_text_field.dart';
import 'color_circle.dart';
import 'icon_circle.dart';

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
        _titleError = "Поле должно быть заполнено.";
      });
    }

    if (_titleError == null) {
      widget.onCategoryChange(
        EventCategory(
          categoryIconID: _selectedIcon,
          categoryColor: _selectedColor.value,
          categoryTitle: _categoryTitle,
        ),
        viewModel.categoryList.indexOf(_category)
      );
    }
  }

  void _removeCategory() async {
    Navigator.pop(context);
    await viewModel.removeCategory(_category);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: AppShapes.roundedRectangleShape,
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                      const Text(
                        "Настройка категории",
                        style: TextStyle(
                          fontSize: 16,
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
                  CategoryDropdown(
                      value: _category,
                      items: viewModel.categoryList,
                      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                      onChanged: (eventCategory) {
                        setState(() {
                          _category = eventCategory;
                          _titleController.text = _category.categoryTitle;
                          _categoryTitle = _category.categoryTitle;
                        });
                      }
                  ),
                  const SizedBox(height: 8),
                  AppTextField(
                    hint: "Название",
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
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 0,
                    color: Theme.of(context).cardColor,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Цвет",
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                              constraints: const BoxConstraints(maxHeight: 170),
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 58),
                                  scrollDirection: Axis.vertical,
                                  itemCount: AppColors().categoryColors.length,
                                  itemBuilder: (rowContext, index) {
                                    Color color = AppColors().categoryColors[index];
                                    return ColorCircle(
                                        color: color,
                                        isSelected: Color(color.value) == _selectedColor,
                                        onSelect: (c) {
                                          setState(() {
                                            _selectedColor = c;
                                          });
                                        }
                                    );
                                  }
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 0,
                    color: Theme.of(context).cardColor,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Иконка",
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                              constraints: const BoxConstraints(maxHeight: 170),
                              child:
                              GridView.builder(
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
                                  }
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      viewModel.categoryList.length > 1 ? AppTextButton(
                        label: "Удалить",
                        onPressed: _removeCategory,
                      ) : const SizedBox(),
                      FloatingActionButton(
                        elevation: 0,
                        onPressed: _saveCategory,
                        tooltip: "Сохранить категорию",
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