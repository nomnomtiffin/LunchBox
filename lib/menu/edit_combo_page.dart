import 'package:flutter/material.dart';
import 'package:lunch_box/model/combo.dart';
import 'package:lunch_box/model/menu.dart';
import 'package:lunch_box/model/menu_item.dart';
import 'package:lunch_box/provider/menu_factory.dart';

class EditComboPage extends StatefulWidget {
  const EditComboPage(this.selectedDate, this.selectedCombo, {Key? key})
      : super(key: key);
  final DateTime selectedDate;
  final Combo selectedCombo;

  @override
  State<EditComboPage> createState() => _EditComboPageState();
}

class _EditComboPageState extends State<EditComboPage> {
  List<MenuItem> _selectedMenuItems = [];
  final _formKey = GlobalKey<FormState>();
  var _comboName = '';
  int _comboPrice = 0;
  List<MenuItem> menuItems = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _selectedMenuItems = widget.selectedCombo.comboItems;
    _comboName = widget.selectedCombo.comboName;
    _comboPrice = widget.selectedCombo.comboPrice;
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
              TextFormField(
                maxLength: 50,
                initialValue: widget.selectedCombo.comboName,
                decoration: const InputDecoration(
                  label: Text('Combo Name'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _comboName = value!;
                },
              ),
              TextFormField(
                initialValue: widget.selectedCombo.comboPrice.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text('Combo Price'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null ||
                      int.tryParse(value)! <= 0) {
                    return 'Must be a valid, positive number.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _comboPrice = int.parse(value!);
                },
              ),
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
                    child: const Text('Edit Combo'),
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
      Combo newCombo = Combo(
          comboName: _comboName,
          comboPrice: _comboPrice,
          comboItems: _selectedMenuItems);
      Menu? menuByDate = await MenuFactory.getMenuByDate(widget.selectedDate);
      if (menuByDate == null) {
        List<Combo> combos = [newCombo];
        menuByDate = Menu(
            menuDate: widget.selectedDate,
            menuItems: _selectedMenuItems.toList(),
            combos: combos);
      } else {
        var combos = menuByDate.combos;
        Map<String, int> menuItemCount = {};
        Map<String, MenuItem> menuItemMap = {};
        for (Combo combo in combos) {
          for (MenuItem menuItem in combo.comboItems) {
            int count = menuItemCount[menuItem.name] ?? 0;
            menuItemCount[menuItem.name] = count++;
            menuItemMap[menuItem.name] = menuItem;
          }
        }
        for (Combo combo in combos) {
          if (combo.comboName == widget.selectedCombo.comboName) {
            combos.remove(combo);
            combos.add(newCombo);
            //Remove all the old
            for (MenuItem menuItem in combo.comboItems) {
              int count = menuItemCount[menuItem.name] ?? 0;
              if ((count - 1) > 0) {
                menuItemCount[menuItem.name] = count - 1;
              } else {
                menuItemCount.remove(menuItem.name);
                menuItemMap.remove(menuItem.name);
              }
            }
            //Add menuItems of the new combo
            for (MenuItem menuItem in newCombo.comboItems) {
              if (!menuItemMap.containsKey(menuItem.name)) {
                menuItemMap[menuItem.name] = menuItem;
              }
            }
            int menuCount = menuByDate.menuItems.length;
            for (int i = 0; i < menuCount; i++) {
              menuByDate.menuItems.removeAt(0);
            }
            List<MenuItem> newMenuItemList = [];
            for (MapEntry entries in menuItemMap.entries) {
              newMenuItemList.add(entries.value);
            }
            newMenuItemList.sort((a, b) => a.order.compareTo(b.order));
            for (MenuItem menuItem in newMenuItemList) {
              menuByDate.menuItems.add(menuItem);
            }
            break;
          }
        }
      }
      MenuFactory.setMenuByDate(widget.selectedDate, menuByDate);
      Navigator.pop(context);
    }
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

  populateMenuItem(List<MenuItem> value) {
    List<MenuItem> tempMeniItems = List.empty(growable: true);
    for (MenuItem menuItem in value) {
      tempMeniItems.add(menuItem);
    }
    setState(() {
      menuItems = tempMeniItems;
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
