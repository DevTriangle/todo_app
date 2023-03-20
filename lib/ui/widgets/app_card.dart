import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/event_category.dart';
import 'package:todo_app/ui/shapes.dart';
import 'package:todo_app/utils/format_time.dart';
import 'package:todo_app/utils/get_date.dart';

class AppCard extends StatefulWidget {
  final String title;
  final DateTime destination;
  final String icon;
  final Color color;
  final Function() onClick;

  const AppCard({
    super.key,
    required this.title,
    required this.destination,
    required this.icon,
    required this.color,
    required this.onClick
  });

  @override
  State<StatefulWidget> createState() => AppCardState();
}

class AppCardState extends State<AppCard> {
  DateFormat date = DateFormat("dd.MM.yyyy HH:mm");

  Duration timeLeft = Duration();

  int secondsLeft = 0;
  int minutesLeft = 0;
  int hoursLeft = 0;
  int daysLeft = 0;
  int monthLeft = 0;
  int yearLeft = 0;

  Map<String, int> timeLeftMap = <String, int>{};
  String displayLeft = "";

  @override
  void initState() {
    super.initState();

    displayDate();
  }

  void displayDate() async {
    final periodicTimer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        timeLeft = widget.destination.difference(DateTime.now());

        timeLeftMap = calculateRemainingTime(widget.destination);

        setState(() {
          if (widget.destination.isBefore(DateTime.now())) {
            displayLeft = "В прогрессе";
          } else {
            displayLeft = formatTime(
                timeLeftMap['years']!,
                timeLeftMap['months']!,
                timeLeftMap['days']!,
                timeLeftMap['hours']!,
                timeLeftMap['minutes']!,
                timeLeftMap['seconds']!
            );
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 10),
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: AppShapes.borderRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            onTap: widget.onClick,
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: Border(
                  left: BorderSide(color: widget.color, width: 6, strokeAlign: StrokeAlign.inside)
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            widget.icon,
                            color: widget.color,
                            width: 30, height: 30,
                          ),
                          const SizedBox(width: 10),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.45
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      height: 1.1
                                  ),
                                  softWrap: true,
                                ),
                                Text(
                                  date.format(widget.destination),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).hintColor.withOpacity(0.65)
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        displayLeft,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14
                        ),
                      )
                    ]
                ),
              ),
            )
        )
    );
  }
}