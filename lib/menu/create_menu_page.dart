import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunch_box/menu/add_combo_page.dart';
import 'package:lunch_box/menu/copy_menu_page.dart';
import 'package:lunch_box/menu/edit_combo_page.dart';
import 'package:lunch_box/menu/edit_custom_menu_page.dart';
import 'package:lunch_box/model/combo.dart';
import 'package:lunch_box/model/menu.dart';
import 'package:lunch_box/model/menu_item.dart';
import 'package:lunch_box/provider/menu_factory.dart';

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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    MenuFactory.getMenuByDate(widget.selectedDate)
        .then((value) => setState(() => {loadContent(value)}));
  }

  @override
  Widget build(BuildContext context) {
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
              menu = await MenuFactory.getMenuByDate(widget.selectedDate);
              setState(() {
                setContent();
              });
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  child: Text('Add Thali'),
                  value: 0,
                ),
                const PopupMenuItem(
                  child: Text('Edit Thali'),
                  value: 1,
                ),
                const PopupMenuItem(
                  child: Text('Remove Thali'),
                  value: 2,
                ),
                const PopupMenuItem(
                  child: Text('Edit Custom Thali'),
                  value: 3,
                )
              ];
            },
            onSelected: (value) async {
              if (value == 0) {
                await OnClickAddCombo(context);
              } else if (value == 1) {
                await onClickEditCombo(context);
              } else if (value == 2) {
                onClickRemoveCombo(context);
              } else if (value == 3) {
                await onClickEditMenu(context);
              }
            },
          ),
        ],
      ),
      body: setContent(),
    );
  }

  void onClickRemoveCombo(BuildContext context) {
    if (selectedCombos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a combo to delete!")));
    } else {
      showAlertDialog(context);
    }
  }

  onClickEditMenu(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => EditCustomMenuPage(
            widget.selectedDate, menu != null ? menu!.menuItems : [])));
    menu = await MenuFactory.getMenuByDate(widget.selectedDate);
    setState(() {
      selectedCombos = [];
      setContent();
    });
  }

  Future<void> onClickEditCombo(BuildContext context) async {
    if (selectedCombos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a combo to edit!")));
    } else if (selectedCombos.length > 1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please select only one combo to edit!")));
    } else {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) =>
              EditComboPage(widget.selectedDate, selectedCombos[0])));
      menu = await MenuFactory.getMenuByDate(widget.selectedDate);
      setState(() {
        selectedCombos = [];
        setContent();
      });
    }
  }

  Future<void> OnClickAddCombo(BuildContext context) async {
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => AddComboPage(widget.selectedDate)));
    menu = await MenuFactory.getMenuByDate(widget.selectedDate);
    setState(() {
      setContent();
    });
  }

  Widget setContent() {
    content = isLoading
        ? const Center(
            child: SizedBox(
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
              height: 50.0,
              width: 50.0,
            ),
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "No menu available for the selected date ${DateFormat("d MMM yyy").format(widget.selectedDate)}"),
            ),
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
      onPressed: () async {
        Menu? menuByDate = await MenuFactory.getMenuByDate(widget.selectedDate);
        var combos = menuByDate!.combos;
        for (Combo selectedCombo in selectedCombos) {
          for (Combo combo in combos) {
            if (combo.comboName == selectedCombo.comboName) {
              combos.remove(combo);
              break;
            }
          }
        }
        MenuFactory.setMenuByDate(widget.selectedDate, menuByDate);
        menu = await MenuFactory.getMenuByDate(widget.selectedDate);
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

  loadContent(Menu? value) {
    menu = value;
    isLoading = false;
  }
}
