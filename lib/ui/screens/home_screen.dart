import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/app_event.dart';
import 'package:todo_app/model/event_category.dart';
import 'package:todo_app/ui/icons.dart';
import 'package:todo_app/ui/screens/manage_event_screen.dart';
import 'package:todo_app/ui/screens/settings_screen.dart';
import 'package:todo_app/ui/widgets/app_card.dart';
import 'package:todo_app/ui/widgets/app_dialog.dart';
import 'package:todo_app/ui/widgets/error_container.dart';
import 'package:todo_app/viewmodel/home_viewmodel.dart';

import '../widgets/app_button.dart';
import '../widgets/category_dialog.dart';
import '../../model/response.dart';
import '../../utils/get_date.dart';
import '../shapes.dart';
import '../widgets/app_snackbar_content.dart';
import '../widgets/bottom_sheet_button.dart';
import '../widgets/bottom_sheet_card.dart';

class HomeScreen extends StatefulWidget {
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

    _displayDateText = getCurrentDate();
    viewModel = Provider.of<HomeViewModel>(context, listen: false);

    _loadEvents = _getEvents();
    _getCategories = _loadCategories();
  }

  Future<Response> _getEvents() async {
    Response eventResponse = await viewModel.loadEvents();

    return eventResponse;
  }

  Future<Response> _loadCategories() async {
    Response categoriesResponse = await viewModel.loadCategories();

    return categoriesResponse;
  }

  void _createDialog({ int index = 0, bool isEditing = false}) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(
            builder: (mContext, setState) {
              int i = viewModel.categoryList.indexWhere((element) => element.categoryTitle == viewModel.eventList[index].eventCategory.categoryTitle &&
                  element.categoryIconID == viewModel.eventList[index].eventCategory.categoryIconID &&
                  element.categoryColor == viewModel.eventList[index].eventCategory.categoryColor
              );

              return AppDialog(
                  title: isEditing ? viewModel.eventList[index].title : "",
                  destination: isEditing ? DateTime.parse(viewModel.eventList[index].datetime) : DateTime.now(),
                  categoryIndex: isEditing ? i != -1 ? i : 0 : 0,
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
                  isEditing: isEditing
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
                    _createCategory(category);
                    Navigator.pop(context);
                  }
              );
            },
          );
        }
    );
  }

  void _createEvent(AppEvent event) async {
    Response createResponse = await viewModel.createEvent(event);

    final snackBar = SnackBar(
        shape: AppShapes.roundedRectangleShape,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        behavior: SnackBarBehavior.floating,
        content: AppSnackBarContent(
            label: createResponse.message,
            icon: Icons.info_rounded
        )
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    setState(() {
      _loadEvents = _getEvents();
    });
  }

  void _createCategory(EventCategory category) async {
    Response createResponse = await viewModel.createCategory(category);

    final snackBar = SnackBar(
        shape: AppShapes.roundedRectangleShape,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        behavior: SnackBarBehavior.floating,
        content: AppSnackBarContent(
            label: createResponse.message,
            icon: Icons.info_rounded
        )
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    setState(() {
      _loadEvents = _getEvents();
    });
  }

  void _editEvent(int index, AppEvent newEvent) async {
    Response createResponse = await viewModel.editEvent(index, newEvent);

    final snackBar = SnackBar(
        shape: AppShapes.roundedRectangleShape,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        behavior: SnackBarBehavior.floating,
        content: AppSnackBarContent(
            label: createResponse.message,
            icon: Icons.info_rounded
        )
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    setState(() {
      _loadEvents = _getEvents();
    });
  }

  void _removeEvent(AppEvent event) async {
    Response createResponse = await viewModel.removeEvent(event);

    final snackBar = SnackBar(
        shape: AppShapes.roundedRectangleShape,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        behavior: SnackBarBehavior.floating,
        content: AppSnackBarContent(
            label: createResponse.message,
            icon: Icons.info_rounded
        )
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    setState(() {
      _loadEvents = _getEvents();
    });
  }

  void _openSettings() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
            child: Scaffold(
                floatingActionButton: FutureBuilder(
                  future: _getCategories,
                  builder: (fContext, snapshot) {
                    if (snapshot.data != null) {
                      if (snapshot.data!.isSuccess) {
                        return FloatingActionButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                elevation: 0.0,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return BottomSheetCard(
                                      children: [
                                        BottomSheetButton(
                                          icon: Icons.calendar_month_rounded,
                                          label: "Добавить новое событие",
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _createDialog();
                                          },
                                        ),
                                        BottomSheetButton(
                                          icon: Icons.category_rounded,
                                          label: "Добавить новую категорию",
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _createCategoryDialog();
                                          },
                                        )
                                      ]
                                  );
                                }
                            );
                          },
                          tooltip: "Добавить",
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                child: Text(
                                  "События",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).hintColor
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                                    child: Text(
                                        _displayDateText,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).hintColor.withOpacity(0.65),
                                        )
                                    ),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: AppIconButton(
                                        icon: Icons.settings_rounded,
                                        onPressed: _openSettings,
                                      )
                                  )
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
                                            return AppCard(
                                                title: viewModel.eventList[index].title,
                                                destination: DateTime.parse(viewModel.eventList[index].datetime),
                                                icon: AppIcons().iconsList[viewModel.eventList[index].eventCategory.categoryIconID],
                                                color: Color(viewModel.eventList[index].eventCategory.categoryColor),
                                                onClick: () {
                                                  _createDialog(index: index, isEditing: true);
                                                }
                                            );
                                          }
                                      );
                                    } else {
                                      return  Center(
                                        child: ErrorContainer(
                                            icon: Icons.notes_rounded,
                                            label: snapshot.data!.message
                                        ),
                                      );
                                    }
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                }
                            )
                          ])
                      )
                    ]
                )
            )
        )
    );
  }
}