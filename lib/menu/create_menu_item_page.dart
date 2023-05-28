import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunch_box/menu/add_combo_page.dart';
import 'package:lunch_box/model/combo.dart';
import 'package:lunch_box/model/menu.dart';
import 'package:lunch_box/model/menu_item.dart';
import 'package:lunch_box/util/dummy_menu.dart';

class CreateMenuItemPage extends StatelessWidget {
  const CreateMenuItemPage({Key? key, required this.selectedDate})
      : super(key: key);

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    Menu? menu = DummyMenu.getMenuByDate(selectedDate);
    Widget content = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
          "No menu available for the selected date ${DateFormat("d MMM yyy").format(selectedDate)}"),
    );
    if (menu != null) {
      DateTime menuDate = menu.menuDate;
      content = SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Today\'s Menu - ${menuDate.day}-${menuDate.month}-${menuDate.year}',
              ),
              ...getMenuItems(menu)
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Menu for ${DateFormat("d MMM").format(selectedDate)}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => AddComboPage()));
            },
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).secondaryHeaderColor),
            child: const Text('Add Combo'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => AddComboPage()));
            },
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).secondaryHeaderColor),
            child: const Text('Edit Combo'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => AddComboPage()));
            },
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).secondaryHeaderColor),
            child: const Text('Remove Combo'),
          ),
        ],
      ),
      body: content,
    );
  }

  List<Widget> getMenuItems(Menu menu) {
    List<Widget> menuItems = List.empty(growable: true);

    //Display Combo
    for (Combo combo in menu.combos) {
      String comboDescription = '';
      for (MenuItem item in combo.comboItems) {
        if (comboDescription.isNotEmpty) {
          comboDescription += ', ';
        }
        comboDescription += item.name;
      }

      menuItems.add(Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  combo.comboName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  comboDescription,
                ),
              ],
            ),
            const Spacer(),
            Text(
              '₹ ${combo.comboPrice}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ));
    }

    //Display menu items
    Map<String, List<MenuItem>> categories = {};
    for (MenuItem item in menu.menuItems) {
      List<MenuItem> menuItems;
      if (categories.keys.contains(item.type)) {
        menuItems = categories[item.type]!;
      } else {
        menuItems = List.empty(growable: true);
      }
      menuItems.add(item);
      categories[item.type] = menuItems;
    }

    for (String key in categories.keys) {
      menuItems.add(Row(
        children: [
          Text(
            key,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ));

      List<MenuItem> items = categories[key]!;
      for (MenuItem menuItem in items) {
        menuItems.add(Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
              child: Text(
                menuItem.name,
              ),
            ),
            const Spacer(),
            Text(
              '₹ ${menuItem.price}',
            )
          ],
        ));
      }
    }

    return menuItems;
  }
}
