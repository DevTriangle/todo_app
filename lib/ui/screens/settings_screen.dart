import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/ui/widgets/setting_category_dialog.dart';
import 'package:todo_app/ui/widgets/settings_field.dart';

import '../../model/event_category.dart';
import '../../model/response.dart';
import '../../viewmodel/home_viewmodel.dart';
import '../shapes.dart';
import '../widgets/app_button.dart';
import '../widgets/app_snackbar_content.dart';
import '../widgets/category_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  late HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = Provider.of<HomeViewModel>(context, listen: false);
  }

  void _settingCategories() {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(
            builder: (mContext, setState) {
              return SettingCategoryDialog(
                  onCloseClick: () {
                    Navigator.pop(context);
                  },
                  onCategoryChange: (eventCategory, index) {
                    viewModel.editCategory(index, eventCategory);
                    Navigator.pop(context);
                  },
              );
            },
          );
        }
    );
  }

  void _createCategoryDialog() {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(
            builder: (mContext, setState) {
              return AppCategoryDialog(
                  onCloseClick: () {
                    Navigator.pop(context);
                  },
                  onCategoryCreate: (category) async {
                    Navigator.pop(context);
                    _createCategory(category);
                  }
              );
            },
          );
        }
    );
  }

  void _createCategory(EventCategory category) async {
    Response categoryResponse = await viewModel.createCategory(category);

    if (categoryResponse.isSuccess) {
      final snackBar = SnackBar(
          shape: AppShapes.roundedRectangleShape,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          behavior: SnackBarBehavior.floating,
          content: const AppSnackBarContent(
              label: "Категория создана!",
              icon: Icons.info_rounded
          )
      );
      _showSnackbar(snackBar);
    }
  }

  void _showSnackbar(SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
            child: Scaffold(
                body: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        floating: false,
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.transparent,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.parallax,
                          background: ConstrainedBox(
                              constraints: const BoxConstraints.expand(),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5.0,sigmaY: 5.0),
                                child: Container(
                                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.background.withOpacity(0.65)),
                                ),
                              )
                          ),
                          centerTitle: false,
                          titlePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: AppIconButton(
                                        icon: Icons.arrow_back_rounded,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                  )
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                                child: Text(
                                  "Настройки",
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).hintColor
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverList(
                          delegate: SliverChildListDelegate([
                            SettingsField(
                                title: "Создать категорию",
                                description: "Создать новую категорию",
                                trailingWidget: Icon(
                                  Icons.add_rounded,
                                  color: Theme.of(context).hintColor,
                                ),
                                onPressed: _createCategoryDialog
                            ),
                            SettingsField(
                                title: "Настройка категорий",
                                description: "Настройка добавленных категорий",
                                trailingWidget: Icon(
                                  Icons.edit_rounded,
                                  color: Theme.of(context).hintColor,
                                ),
                                onPressed: _settingCategories
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Версия приложения: 1.0",
                              style: TextStyle(
                                color: Theme.of(context).hintColor.withOpacity(0.5),
                                fontSize: 12
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ])
                      )
                    ]
                )
            )
        )
    );
  }
}