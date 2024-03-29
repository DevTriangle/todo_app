import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/utils/format_time.dart';
import 'package:todo_app/utils/get_date.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppCard extends StatefulWidget {
  final String title;
  final DateTime destination;
  final String icon;
  final Color color;
  final Function() onClick;

  const AppCard({super.key, required this.title, required this.destination, required this.icon, required this.color, required this.onClick});

  @override
  State<StatefulWidget> createState() => AppCardState();
}

class AppCardState extends State<AppCard> {
  DateFormat date = DateFormat("dd.MM.yyyy HH:mm");

  Duration timeLeft = const Duration();

  int secondsLeft = 0;
  int minutesLeft = 0;
  int hoursLeft = 0;
  int daysLeft = 0;
  int monthLeft = 0;
  int yearLeft = 0;

  Map<String, int> timeLeftMap = <String, int>{};
  String displayLeft = "";

  late Timer timer;

  @override
  void initState() {
    super.initState();

    displayDate();
  }

  void displayDate() async {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        timeLeft = widget.destination.difference(DateTime.now());

        timeLeftMap = calculateRemainingTime(widget.destination);

        setState(() {
          if (widget.destination.isBefore(DateTime.now())) {
            displayLeft = AppLocalizations.of(context).event_in_progress;
          } else {
            displayLeft = formatTime(timeLeftMap['years']!, timeLeftMap['months']!, timeLeftMap['days']!, timeLeftMap['hours']!, timeLeftMap['minutes']!,
                timeLeftMap['seconds']!, context);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        margin: const EdgeInsets.all(0),
        color: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            onTap: widget.onClick,
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: Border(left: BorderSide(color: widget.color, width: 6, strokeAlign: BorderSide.strokeAlignInside)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        widget.icon,
                        color: widget.color,
                        width: 30.0,
                        height: 30.0,
                      ),
                      const SizedBox(width: 10),
                      Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.45),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Theme.of(context).hintColor, height: 1.1),
                              softWrap: true,
                            ),
                            Text(
                              date.format(widget.destination),
                              style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor.withOpacity(0.65), fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.3),
                    child: Text(
                      displayLeft,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Theme.of(context).hintColor),
                      textAlign: TextAlign.right,
                    ),
                  )
                ]),
              ),
            )));
  }

  @override
  void dispose() {
    super.dispose();

    timer.cancel();
  }
}
