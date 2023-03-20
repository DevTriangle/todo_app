import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/app_event.dart';
import 'package:todo_app/model/event_category.dart';
import 'package:todo_app/ui/icons.dart';
import 'package:todo_app/ui/screens/manage_event_screen.dart';
import 'package:todo_app/ui/widgets/app_card.dart';
import 'package:todo_app/ui/widgets/app_dialog.dart';
import 'package:todo_app/ui/widgets/error_container.dart';
import 'package:todo_app/viewmodel/home_viewmodel.dart';

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

  void _createDialog({ int index = -1, bool isEditing = false}) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(
            builder: (mContext, setState) {
              return AppDialog(
                title: isEditing ? viewModel.eventList[index].title : "",
                destination: isEditing ? DateTime.parse(viewModel.eventList[index].datetime) : DateTime.now(),
                categoryIndex: isEditing ? viewModel.categoryList.indexWhere((element) => element.categoryTitle == viewModel.eventList[index].eventCategory.categoryTitle &&
                    element.categoryIconID == viewModel.eventList[index].eventCategory.categoryIconID &&
                    element.categoryColor == viewModel.eventList[index].eventCategory.categoryColor
                ) : 0,
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
                body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverAppBar(
                            elevation: 0,
                            automaticallyImplyLeading: false,
                            backgroundColor: Colors.transparent,
                            flexibleSpace: FlexibleSpaceBar(
                              collapseMode: CollapseMode.parallax,
                              centerTitle: false,
                              titlePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "События",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  Text(
                                    _displayDateText,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).hintColor.withOpacity(0.65),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SliverFillRemaining(
                              child: FutureBuilder(
                                  future: _loadEvents,
                                  builder: (fContext, snapshot) {
                                    if (snapshot.data != null) {
                                      if (snapshot.data!.isSuccess && viewModel.eventList.isNotEmpty) {
                                        return ListView.builder(
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
                                        return ErrorContainer(
                                            icon: Icons.note,
                                            label: snapshot.data!.message
                                        );
                                      }
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  }
                              )
                          )
                        ]
                    )
                )
            )
        )
    );
  }
}