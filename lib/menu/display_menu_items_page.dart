import 'package:flutter/material.dart';
import 'package:lunch_box/menu/edit_menu_item_page.dart';
import 'package:lunch_box/provider/menu_factory.dart';

import '../model/menu_item.dart';
import 'add_menu_item_page.dart';

class DisplayMenuItemsPage extends StatefulWidget {
  const DisplayMenuItemsPage({Key? key}) : super(key: key);

  @override
  State<DisplayMenuItemsPage> createState() => _DisplayMenuItemsPageState();
}

class _DisplayMenuItemsPageState extends State<DisplayMenuItemsPage> {
  List<MenuItem> _menuItems = [];
  List<MenuItem> _selectedMenuItem = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MenuFactory.getAllMenu().then((value) => {
          setState(() {
            _menuItems = List.from(value);
          })
        });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Items"),
        actions: [
          TextButton(
            child: const Text('Add Item'),
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).secondaryHeaderColor),
            onPressed: () async {
              await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => AddMenuItemPage()));
              setState(() {
                MenuFactory.getAllMenu()
                    .then((value) => _menuItems = List.from(value));
              });
            },
          ),
          TextButton(
            child: const Text('Edit Item'),
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).secondaryHeaderColor),
            onPressed: () async {
              if (_selectedMenuItem.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please select a item to edit!")));
              } else if (_selectedMenuItem.length > 1) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please select only one item to edit!")));
              } else {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => EditMenuItemPage(_selectedMenuItem[0])));
                setState(() {
                  _selectedMenuItem = [];
                  MenuFactory.getAllMenu()
                      .then((value) => _menuItems = List.from(value));
                });
              }
            },
          ),
        ],
      ),
      body: ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex--;
            }
            MenuItem value = _menuItems.removeAt(oldIndex);

            _menuItems.insert(newIndex, value);
            MenuFactory.setMenuItem(_menuItems);
          });
        },
        children: [
          for (MenuItem menuItem in _menuItems)
            ListTile(
              key: ValueKey(menuItem.id),
              title: Row(
                children: [
                  Checkbox(
                    value: _selectedMenuItem.contains(menuItem),
                    onChanged: (value) => {
                      setState(() {
                        if (value == null || value == false) {
                          _selectedMenuItem.remove(menuItem);
                        } else {
                          _selectedMenuItem.add(menuItem);
                        }
                      })
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menuItem.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(menuItem.type),
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 17.0, 0.0),
                    child: Text('₹ ${menuItem.price.toString()}'),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
