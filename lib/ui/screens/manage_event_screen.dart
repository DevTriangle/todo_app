import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/event_category.dart';
import 'package:todo_app/ui/shapes.dart';
import 'package:todo_app/ui/widgets/ColorCircle.dart';
import 'package:todo_app/ui/widgets/app_dropdown.dart';
import 'package:todo_app/ui/widgets/app_text_field.dart';

class ManageEventScreen extends StatefulWidget {
  const ManageEventScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => ManageEventScreenState();
}

class ManageEventScreenState extends State<ManageEventScreen> {
  List<EventCategory> categoryList = <EventCategory>[
    EventCategory(categoryTitle: "Праздники", categoryIcon: Icons.celebration_rounded, categoryColor: Colors.amber),
    EventCategory(categoryTitle: "Дни рождения", categoryIcon: Icons.cake_rounded, categoryColor: Colors.redAccent),
    EventCategory(categoryTitle: "Другое", categoryIcon: Icons.more_horiz_rounded, categoryColor: Colors.grey),
  ];

  late EventCategory category = categoryList[0];
  late Color selectedColor = colors[0];

  List<Color> colors = <Color>[
    Colors.redAccent,
    Colors.pink,
    Colors.amber,
    Colors.blueAccent,
    Colors.purple,
    Colors.indigo,
    Colors.lightGreen,
    Colors.deepOrange,
    Colors.deepOrange,
    Colors.deepOrange,
    Colors.deepOrange,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Создание события",
                      style: TextStyle(
                        fontSize: 20,
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
                        onTap: (){
                          Navigator.pop(context);
                        },
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
                AppTextField(
                    hint: "Название",
                    margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 3),
                    onChanged: (value) {

                    }
                ),
                CategoryDropdown(
                    value: category,
                    items: categoryList,
                    onChanged: (eventCategory) {
                      setState(() {
                        category = eventCategory;
                      });
                    }
                ),
                Container(
                  height: 33,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: colors.length,
                      itemBuilder: (rowContext, index) {
                        Color color = colors[index];
                        return ColorCircle(
                            color: color,
                            isSelected: color == selectedColor,
                            onSelect: (c) {
                              setState(() {
                                selectedColor = c;
                                print(color == selectedColor);
                              });
                            }
                        );
                      }
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}