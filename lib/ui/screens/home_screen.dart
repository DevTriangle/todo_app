import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/app_event.dart';
import 'package:todo_app/model/event_category.dart';
import 'package:todo_app/ui/icons.dart';
import 'package:todo_app/ui/screens/settings_screen.dart';
import 'package:todo_app/ui/widgets/app_alert_dialog.dart';
import 'package:todo_app/ui/widgets/app_card.dart';
import 'package:todo_app/ui/widgets/app_dialog.dart';
import 'package:todo_app/ui/widgets/error_container.dart';
import 'package:todo_app/utils/notification_service.dart';
import 'package:todo_app/viewmodel/home_viewmodel.dart';

import '../widgets/app_button.dart';
import '../widgets/category_dialog.dart';
import '../../model/response.dart';
import '../../utils/get_date.dart';
import '../shapes.dart';
import '../widgets/app_snackbar_content.dart';
import '../widgets/bottom_sheet_button.dart';
import '../widgets/bottom_sheet_card.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late String _displayDateText = "";
  late HomeViewModel viewModel;

  late Future<Response> _loadEvents;
  late Future<Response> _getCategories;

  @override
  void initState() {
    super.initState();

    viewModel = Provider.of<HomeViewModel>(context, listen: false);

    _loadEvents = _getEvents();
    _getCategories = _loadCategories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _displayDateText = getCurrentDate(context);
    viewModel.context = context;
  }

  Future<Response> _getEvents() async {
    Response eventResponse = await viewModel.loadEvents();

    return eventResponse;
  }

  Future<Response> _loadCategories() async {
    Response categoriesResponse = await viewModel.loadCategories();

    return categoriesResponse;
  }

  void _createDialog({int index = 0, bool isEditing = false}) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(
            builder: (mContext, setState) {
              int i = index;

              if (isEditing) {
                i = viewModel.categoryList.indexWhere((element) =>
                    element.categoryTitle == viewModel.eventList[index].eventCategory.categoryTitle &&
                    element.categoryIconID == viewModel.eventList[index].eventCategory.categoryIconID &&
                    element.categoryColor == viewModel.eventList[index].eventCategory.categoryColor);
              }

              return AppDialog(
                  title: isEditing ? viewModel.eventList[index].title : "",
                  destination: isEditing ? DateTime.parse(viewModel.eventList[index].datetime) : DateTime.now(),
                  categoryIndex: isEditing
                      ? i != -1
                          ? i
                          : 0
                      : 0,
                  onCloseClick: () {
                    Navigator.pop(context);
                  },
                  onEventCreate: (event) async {
                    if (isEditing) {
                      _editEvent(index, event);
                    } else {
                      _createEvent(event);
                    }
                    Navigator.pop(context);
                  },
                  onRemoveClick: () {
                    _removeEvent(viewModel.eventList[index]);
                    Navigator.pop(context);
                  },
                  isEditing: isEditing);
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
                _createCategory(category);
                Navigator.pop(context);
              });
            },
          );
        });
  }

  void _createEvent(AppEvent event) async {
    await viewModel.createEvent(event);

    setState(() {
      _loadEvents = _getEvents();
    });
  }

  void _createCategory(EventCategory category) async {
    await viewModel.createCategory(category);

    setState(() {
      _loadEvents = _getEvents();
    });
  }

  void _editEvent(int index, AppEvent newEvent) async {
    await viewModel.editEvent(index, newEvent);

    setState(() {
      _loadEvents = _getEvents();
    });
  }

  Future<bool?> confirmRemove(DismissDirection direction) async {
    bool result = false;
    await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AppAlertDialog(
              title: AppLocalizations.of(context).delete_dialog_title,
              description: AppLocalizations.of(context).delete_dialog_description,
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

  void _removeEvent(AppEvent event) async {
    Response removeResponse = await viewModel.removeEvent(event);

    if (removeResponse.isSuccess) {
      final snackBar = SnackBar(
          shape: AppShapes.roundedRectangleShape,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          behavior: SnackBarBehavior.floating,
          content: AppSnackBarContent(label: AppLocalizations.of(context).event_delete, icon: Icons.delete));
      _showSnackbar(snackBar);
    }

    setState(() {
      _loadEvents = _getEvents();
    });
  }

  void _showSnackbar(SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _openSettings() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).scaffoldBackgroundColor,
            systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
            statusBarIconBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
            systemNavigationBarIconBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light),
        child: SafeArea(
            child: Scaffold(
                floatingActionButton: FutureBuilder(
                  future: _getCategories,
                  builder: (fContext, snapshot) {
                    if (snapshot.data != null) {
                      if (snapshot.data!.isSuccess) {
                        return FloatingActionButton(
                          elevation: 0,
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                elevation: 0.0,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return BottomSheetCard(children: [
                                    BottomSheetButton(
                                      icon: Icons.calendar_month_rounded,
                                      label: AppLocalizations.of(context).event_add,
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _createDialog();
                                      },
                                    ),
                                    BottomSheetButton(
                                      icon: Icons.category_rounded,
                                      label: AppLocalizations.of(context).category_add,
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _createCategoryDialog();
                                      },
                                    )
                                  ]);
                                });
                          },
                          tooltip: AppLocalizations.of(context).add,
                          heroTag: "fab",
                          child: const Icon(Icons.add_rounded),
                        );
                      } else {
                        return const SizedBox();
                      }
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                            child: Text(
                              AppLocalizations.of(context).events,
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 16),
                                child: Text(_displayDateText,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).hintColor.withOpacity(0.65),
                                    )),
                              ),
                              Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: AppIconButton(
                                    icon: Icons.settings_rounded,
                                    onPressed: _openSettings,
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    FutureBuilder(
                        future: _loadEvents,
                        builder: (fContext, snapshot) {
                          if (snapshot.data != null) {
                            if (snapshot.data!.isSuccess && viewModel.eventList.isNotEmpty) {
                              return ListView.builder(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: viewModel.eventList.length,
                                  itemBuilder: (lContext, index) {
                                    return Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: AppShapes.borderRadius,
                                          child: Dismissible(
                                            key: Key(viewModel.eventList[index].toString()),
                                            dismissThresholds: const {
                                              DismissDirection.endToStart: 0.3,
                                              DismissDirection.startToEnd: 2,
                                            },
                                            background: Card(
                                              elevation: 0,
                                              shape: AppShapes.roundedRectangleShape,
                                              color: Color(viewModel.eventList[index].eventCategory.categoryColor),
                                              margin: const EdgeInsets.all(0),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      viewModel.eventList[index].eventCategory.categoryTitle,
                                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            secondaryBackground: Card(
                                              elevation: 0,
                                              shape: AppShapes.roundedRectangleShape,
                                              color: Theme.of(context).errorColor,
                                              margin: const EdgeInsets.all(0),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(context).delete,
                                                      style: const TextStyle(fontSize: 16, color: Colors.white),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    const Icon(
                                                      Icons.delete_rounded,
                                                      size: 20,
                                                      color: Colors.white,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            confirmDismiss: confirmRemove,
                                            onDismissed: (direction) {
                                              _removeEvent(viewModel.eventList[index]);
                                            },
                                            child: AppCard(
                                                title: viewModel.eventList[index].title,
                                                destination: DateTime.parse(viewModel.eventList[index].datetime),
                                                icon: AppIcons().iconsList[viewModel.eventList[index].eventCategory.categoryIconID],
                                                color: Color(viewModel.eventList[index].eventCategory.categoryColor),
                                                onClick: () {
                                                  _createDialog(index: index, isEditing: true);
                                                }),
                                          ),
                                        ),
                                        const SizedBox(height: 10)
                                      ],
                                    );
                                  });
                            } else {
                              return Container(
                                padding: const EdgeInsets.only(top: 10),
                                child: ErrorContainer(icon: Icons.notes_rounded, label: snapshot.data!.message),
                              );
                            }
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        })
                  ]))
                ]))));
  }
}
