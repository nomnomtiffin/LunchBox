import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunch_box/menu/add_combo_page.dart';
import 'package:lunch_box/menu/copy_menu_page.dart';
import 'package:lunch_box/menu/edit_combo_page.dart';
import 'package:lunch_box/model/combo.dart';
import 'package:lunch_box/model/menu.dart';
import 'package:lunch_box/model/menu_item.dart';
import 'package:lunch_box/util/dummy_menu.dart';

class CreateMenuPage extends StatefulWidget {
  const CreateMenuPage({Key? key, required this.selectedDate})
      : super(key: key);

  final DateTime selectedDate;

  @override
  State<CreateMenuPage> createState() => _CreateMenuPageState();
}

class _CreateMenuPageState extends State<CreateMenuPage> {
  Menu? menu;
  Widget? content;
  List<Combo> selectedCombos = [];

  @override
  Widget build(BuildContext context) {
    menu = DummyMenu.getMenuByDate(widget.selectedDate);

    return Scaffold(
      appBar: AppBar(
        title:
            Text("Menu for ${DateFormat("d MMM").format(widget.selectedDate)}"),
        actions: [
          TextButton(
            child: const Text('Copy'),
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).secondaryHeaderColor),
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => CopyMenuPage(widget.selectedDate)));
              setState(() {
                setContent();
              });
            },
          ),
          TextButton(
            child: const Text('Add Combo'),
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).secondaryHeaderColor),
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => AddComboPage(widget.selectedDate)));
              setState(() {
                setContent();
              });
            },
          ),
          TextButton(
            child: const Text('Edit Combo'),
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).secondaryHeaderColor),
            onPressed: () async {
              if (selectedCombos.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please select a combo to edit!")));
              } else if (selectedCombos.length > 1) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please select only one combo to edit!")));
              } else {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) =>
                        EditComboPage(widget.selectedDate, selectedCombos[0])));
                setState(() {
                  selectedCombos = [];
                  setContent();
                });
              }
            },
          ),
          TextButton(
            child: const Text('Remove Combo'),
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).secondaryHeaderColor),
            onPressed: () async {
              if (selectedCombos.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please select a combo to delete!")));
              } else {
                showAlertDialog(context);
              }
            },
          ),
        ],
      ),
      body: setContent(),
    );
  }

  Widget setContent() {
    content = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
          "No menu available for the selected date ${DateFormat("d MMM yyy").format(widget.selectedDate)}"),
    );
    if (menu != null) {
      DateTime menuDate = menu!.menuDate;
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
              ...getMenuItems(menu!)
            ],
          ),
        ),
      );
    }
    return content!;
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
            Checkbox(
                value: selectedCombos.contains(combo),
                onChanged: (bool? value) {
                  _onComboSelected(value, combo);
                }),
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

  void _onComboSelected(bool? value, Combo combo) {
    setState(() {
      if (value == null || value == false) {
        selectedCombos.remove(combo);
      } else {
        selectedCombos.add(combo);
      }
    });
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget yesButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        Menu? menuByDate = DummyMenu.getMenuByDate(widget.selectedDate);
        var combos = menuByDate!.combos;
        for (Combo selectedCombo in selectedCombos) {
          for (Combo combo in combos) {
            if (combo.comboName == selectedCombo.comboName) {
              combos.remove(combo);
              break;
            }
          }
        }
        DummyMenu.setMenuByDate(widget.selectedDate, menuByDate);
        setState(() {
          selectedCombos = [];
          setContent();
        });
        Navigator.of(context).pop();
      },
    );

    Widget noButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Remove Combo"),
      content: const Text("Are you sure?"),
      actions: [yesButton, noButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
