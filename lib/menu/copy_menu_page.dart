import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunch_box/model/menu.dart';
import 'package:lunch_box/util/dummy_menu.dart';

class CopyMenuPage extends StatefulWidget {
  const CopyMenuPage(this.originDate, {Key? key}) : super(key: key);

  final DateTime originDate;
  @override
  State<CopyMenuPage> createState() => _CopyMenuPageState();
}

class _CopyMenuPageState extends State<CopyMenuPage> {
  var _selectedDate;
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
          selectedDate.weekday != DateTime.sunday &&
          selectedDate.day != widget.originDate.day) {
        onPressedFunction = (value) {
          setState(() {
            _selectedDate = value;
          });
        };
      } else {
        onPressedFunction = null;
      }
      dates.add(Row(
        children: [
          Radio(
            value: selectedDate,
            groupValue: _selectedDate,
            onChanged: onPressedFunction,
          ),
          Text(
              '${DateFormat('d MMM, EEEE').format(selectedDate)}${(selectedDate.day == today.day) ? ' - Today' : ''}'),
        ],
      ));
      count++;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Copy from"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...dates,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _copyMenu,
                          child: const Text('Copy'),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  void _copyMenu() {
    Menu? menuByDate = DummyMenu.getMenuByDate(_selectedDate);
    if (menuByDate != null) {
      Menu newMenu = Menu(
          menuDate: widget.originDate,
          menuItems: List.from(menuByDate.menuItems),
          combos: List.from(menuByDate.combos));
      DummyMenu.setMenuByDate(widget.originDate, newMenu);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Menu not available for this date!")));
    }
  }
}
