import 'package:flutter/material.dart';
import 'package:lunch_box/model/menu.dart';
import 'package:lunch_box/model/menu_item.dart';
import 'package:lunch_box/provider/menu_factory.dart';

class EditCustomMenuPage extends StatefulWidget {
  const EditCustomMenuPage(this.selectedDate, this.currentMenuItems, {Key? key})
      : super(key: key);
  final DateTime selectedDate;
  final List<MenuItem> currentMenuItems;

  @override
  State<EditCustomMenuPage> createState() => _EditCustomMenuPageState();
}

class _EditCustomMenuPageState extends State<EditCustomMenuPage> {
  List<MenuItem> _selectedMenuItems = [];
  final _formKey = GlobalKey<FormState>();
  List<MenuItem> menuItems = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _selectedMenuItems = widget.currentMenuItems;
    MenuFactory.getAllMenu().then((value) => populateMenuItem(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Combo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ...getAllItems(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text('Update Menu'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _selectedMenuItems.sort((a, b) => a.order.compareTo(b.order));
      Menu? menuByDate = await MenuFactory.getMenuByDate(widget.selectedDate);
      if (menuByDate == null) {
        menuByDate = Menu(
            menuDate: widget.selectedDate,
            menuItems: _selectedMenuItems,
            combos: List.empty(growable: true));
      } else {
        menuByDate = Menu(
            menuDate: widget.selectedDate,
            menuItems: _selectedMenuItems,
            combos: menuByDate.combos);
      }
      MenuFactory.setMenuByDate(widget.selectedDate, menuByDate);
      Navigator.pop(context);
    }
  }

  populateMenuItem(List<MenuItem> value) {
    List<MenuItem> tempMeniItems = List.empty(growable: true);
    for (MenuItem menuItem in value) {
      tempMeniItems.add(menuItem);
    }
    setState(() {
      menuItems = tempMeniItems;
    });
  }

  List<Widget> getAllItems() {
    List<Row> rows = List.empty(growable: true);
    for (MenuItem menuItem in menuItems) {
      rows.add(Row(
        children: [
          Checkbox(
              value: isMenuItemSelected(_selectedMenuItems, menuItem),
              onChanged: (bool? value) {
                _onMenuItemSelected(value, menuItem);
              }),
          Text(menuItem.name),
        ],
      ));
    }
    return rows;
  }

  void _onMenuItemSelected(bool? value, MenuItem menuItem) {
    setState(() {
      if (value == null || value == false) {
        removeMenuItem(_selectedMenuItems, menuItem);
      } else {
        _selectedMenuItems.add(menuItem);
      }
    });
  }

  bool isMenuItemSelected(List<MenuItem> selectedMenuItems, MenuItem menuItem) {
    for (MenuItem selectedMenuItem in selectedMenuItems) {
      if (selectedMenuItem.id == menuItem.id) {
        return true;
      }
    }
    return false;
  }

  void removeMenuItem(List<MenuItem> selectedMenuItems, MenuItem menuItem) {
    for (MenuItem selectedMenuItem in selectedMenuItems) {
      if (selectedMenuItem.id == menuItem.id) {
        _selectedMenuItems.remove(selectedMenuItem);
      }
    }
  }
}
