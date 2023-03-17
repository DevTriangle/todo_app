import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/event_category.dart';
import 'package:todo_app/ui/screens/manage_event_screen.dart';
import 'package:todo_app/ui/widgets/app_card.dart';
import 'package:todo_app/ui/widgets/app_dialog.dart';

import '../../utils/get_date.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late String _displayDateText = "";

  List<EventCategory> categoryList = <EventCategory>[
    EventCategory(categoryTitle: "Праздники", categoryIcon: Icons.celebration_rounded, categoryColor: Colors.amber),
    EventCategory(categoryTitle: "Дни рождения", categoryIcon: Icons.cake_rounded, categoryColor: Colors.redAccent),
    EventCategory(categoryTitle: "Другое", categoryIcon: Icons.more_horiz_rounded, categoryColor: Colors.grey),
  ];

  @override
  void initState() {
    super.initState();

    _displayDateText = getCurrentDate();
  }

  void _createDialog() {
    String eventTitle = "";
    EventCategory eventCategory;

    //Navigator.push(context, MaterialPageRoute(builder: (builder) => ManageEventScreen()));

     showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          EventCategory eventCategory;

          return StatefulBuilder(
            builder: (mContext, setState) {
              return AppDialog(
                onCloseClick: () {
                  Navigator.pop(context);
                },
                onTitleChanged: (value) {
                  eventTitle = value;
                },
                onCategoryChanged: (value) {
                  setState(() {
                    eventCategory = value;
                  });
                },
              );
            },
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
            child: Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    _createDialog();
                  },
                  tooltip: "Добавить событие",
                  heroTag: "fab",
                  child: const Icon(Icons.add_rounded),
                ),
                body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child:
                        CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            SliverAppBar(
                              elevation: 0,
                              automaticallyImplyLeading: false,
                              backgroundColor: Colors.transparent,
                              flexibleSpace: FlexibleSpaceBar(
                                collapseMode: CollapseMode.parallax,
                                centerTitle: false,
                                titlePadding: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
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
                            SliverList(delegate: SliverChildListDelegate(
                              [
                                Column(
                                  children: [
                                    AppCard(
                                        title: "Новый год",
                                        destination: DateTime.now(),
                                        icon: Icons.celebration_rounded,
                                        color: Colors.amber
                                    ),
                                    AppCard(
                                        title: "Новый год",
                                        destination: DateTime.now(),
                                        icon: Icons.celebration_rounded,
                                        color: Colors.amber
                                    ),
                                    AppCard(
                                        title: "Новый год",
                                        destination: DateTime.now(),
                                        icon: Icons.celebration_rounded,
                                        color: Colors.amber
                                    ),
                                    AppCard(
                                        title: "Новый год",
                                        destination: DateTime.now(),
                                        icon: Icons.celebration_rounded,
                                        color: Colors.amber
                                    ),
                                    AppCard(
                                        title: "Новый год",
                                        destination: DateTime.now(),
                                        icon: Icons.celebration_rounded,
                                        color: Colors.amber
                                    ),AppCard(
                                        title: "Новый год",
                                        destination: DateTime.now(),
                                        icon: Icons.celebration_rounded,
                                        color: Colors.amber
                                    ),
                                    AppCard(
                                        title: "Новый год",
                                        destination: DateTime.now(),
                                        icon: Icons.celebration_rounded,
                                        color: Colors.amber
                                    ),
                                    AppCard(
                                        title: "День рождения",
                                        destination: DateTime.now(),
                                        icon: Icons.cake_rounded,
                                        color: Colors.deepOrange
                                    ),
                                    AppCard(
                                        title: "Дата с длинным названием (ооооочень длинным)",
                                        destination: DateTime.now(),
                                        icon: Icons.menu,
                                        color: Colors.greenAccent
                                    ),
                                    AppCard(
                                        title: "Дата",
                                        destination: DateTime.now(),
                                        icon: Icons.access_time_rounded,
                                        color: Colors.pink
                                    ),
                                    AppCard(
                                        title: "Дата",
                                        destination: DateTime.now(),
                                        icon: Icons.access_time_rounded,
                                        color: Colors.pink
                                    ),
                                    AppCard(
                                        title: "Дата",
                                        destination: DateTime.now(),
                                        icon: Icons.access_time_rounded,
                                        color: Colors.pink
                                    ),
                                    AppCard(
                                        title: "Дата",
                                        destination: DateTime.now(),
                                        icon: Icons.access_time_rounded,
                                        color: Colors.pink
                                    ),
                                  ],
                                )
                              ]
                            ))
                          ]
                        )
                )
            )
        )
    );
  }
}