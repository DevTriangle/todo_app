import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/model/language.dart';
import 'package:todo_app/ui/widgets/image_circle.dart';
import 'package:todo_app/ui/widgets/setting_category_dialog.dart';
import 'package:todo_app/ui/widgets/settings_field.dart';

import '../../model/event_category.dart';
import '../../model/response.dart';
import '../../viewmodel/home_viewmodel.dart';
import '../shapes.dart';
import '../widgets/app_button.dart';
import '../widgets/app_snackbar_content.dart';
import '../widgets/category_dialog.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  late HomeViewModel viewModel;

  final List<Language> languages = [
    Language("en", "English", "assets/images/en.png"),
    Language("ru", "Русский", "assets/images/ru.png"),
  ];

  String appVersion = "";

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((value) {
      appVersion = value.version;
      setState(() {});
    });

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
        });
  }

  void _createCategoryDialog() {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(
            builder: (mContext, setState) {
              return AppCategoryDialog(onCloseClick: () {
                Navigator.pop(context);
              }, onCategoryCreate: (category) async {
                Navigator.pop(context);
                _createCategory(category);
              });
            },
          );
        });
  }

  void _createCategory(EventCategory category) async {
    Response categoryResponse = await viewModel.createCategory(category);

    if (categoryResponse.isSuccess) {
      final snackBar = SnackBar(
          shape: AppShapes.roundedRectangleShape,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          behavior: SnackBarBehavior.floating,
          content: AppSnackBarContent(label: AppLocalizations.of(context).category_created, icon: Icons.info_rounded));
      _showSnackbar(snackBar);
    }
  }

  void _showSnackbar(SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).scaffoldBackgroundColor,
            systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
            statusBarIconBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
            systemNavigationBarIconBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
              child: Scaffold(
                  body: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
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
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.background.withOpacity(0.65)),
                      ),
                    )),
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
                            ))
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                      child: Text(
                        AppLocalizations.of(context).settings,
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500, color: Theme.of(context).hintColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              SettingsField(
                  title: AppLocalizations.of(context).settings_category_creation_title,
                  description: AppLocalizations.of(context).settings_category_creation_description,
                  trailingWidget: Icon(
                    Icons.add_rounded,
                    color: Theme.of(context).hintColor,
                  ),
                  onPressed: _createCategoryDialog),
              SettingsField(
                  title: AppLocalizations.of(context).settings_category_manage_title,
                  description: AppLocalizations.of(context).settings_category_manage_description,
                  trailingWidget: Icon(
                    Icons.edit_rounded,
                    color: Theme.of(context).hintColor,
                  ),
                  onPressed: _settingCategories),
              Card(
                shape: Border(bottom: BorderSide(width: 0.1, color: Theme.of(context).hintColor)),
                margin: EdgeInsets.zero,
                elevation: 0,
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).language_title,
                        style: TextStyle(fontSize: 18, color: Theme.of(context).hintColor),
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        height: 58,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: languages.length,
                          itemBuilder: (b, index) {
                            return ImageCircle(
                              image: languages[index].image,
                              isSelected: AppLocalizations.of(context).localeName.toLowerCase() == languages[index].locale.toLowerCase(),
                              onSelect: () async {
                                MyApp.of(context).setLocale(languages[index].locale);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "${AppLocalizations.of(context).app_version}$appVersion",
                style: TextStyle(color: Theme.of(context).hintColor.withOpacity(0.5), fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Icons made by Freepik from www.flaticon.com",
                style: TextStyle(color: Theme.of(context).hintColor.withOpacity(0.2), fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ]))
          ]))),
        ));
  }
}
