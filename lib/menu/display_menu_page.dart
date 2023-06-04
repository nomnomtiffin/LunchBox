import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunch_box/menu/create_menu_page.dart';

class DisplayMenuPage extends StatelessWidget {
  const DisplayMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final DateTime previousWeek =
        getDate(today.subtract(const Duration(days: DateTime.daysPerWeek)));
    final DateTime startOfPreviousWeek = getDate(
        previousWeek.subtract(Duration(days: previousWeek.weekday - 1)));

    List<Widget> dates = List.empty(growable: true);
    var count = 0;
    while (count < 15) {
      DateTime selectedDate = startOfPreviousWeek.add(Duration(days: count));
      var onPressedFunction;
      if (selectedDate.weekday != DateTime.saturday &&
          selectedDate.weekday != DateTime.sunday) {
        onPressedFunction = () {
          _createMenuItems(context, selectedDate);
        };
      } else {
        onPressedFunction = null;
      }
      dates.add(TextButton(
        onPressed: onPressedFunction,
        child: Text(
            '${DateFormat('d MMM, EEEE').format(selectedDate)}${(selectedDate.day == today.day) ? ' - Today' : ''}'),
      ));
      count++;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text(""),
        ),
        body: SingleChildScrollView(
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: dates,
              )
            ],
          ),
        ));
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  void _createMenuItems(BuildContext context, DateTime selectedDate) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => CreateMenuPage(selectedDate: selectedDate)));
  }
}
