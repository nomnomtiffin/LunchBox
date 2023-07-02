import 'package:flutter/material.dart';
import 'package:lunch_box/model/combo.dart';
import 'package:lunch_box/model/menu.dart';
import 'package:lunch_box/model/menu_item.dart';
import 'package:lunch_box/provider/menu_factory.dart';

class AddComboPage extends StatefulWidget {
  const AddComboPage(this.selectedDate, {Key? key}) : super(key: key);
  final DateTime selectedDate;

  @override
  State<AddComboPage> createState() => _AddComboPageState();
}

class _AddComboPageState extends State<AddComboPage> {
  List<MenuItem> selectedMenuItems = List.empty(growable: true);
  final _formKey = GlobalKey<FormState>();
  var _comboName = '';
  int _comboPrice = 0;
  List<MenuItem> menuItems = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    MenuFactory.getAllMenu().then((value) => populateMenuItem(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Combo"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
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
                      child: const Text('Add Combo'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      selectedMenuItems.sort((a, b) => a.order.compareTo(b.order));
      Combo newCombo = Combo(
          comboName: _comboName,
          comboPrice: _comboPrice,
          comboItems: selectedMenuItems);
      Menu? menuByDate = await MenuFactory.getMenuByDate(widget.selectedDate);
      if (menuByDate == null) {
        List<Combo> combos = [newCombo];
        menuByDate = Menu(
            menuDate: widget.selectedDate,
            menuItems: List.empty(growable: true),
            combos: combos);
      } else {
        menuByDate.combos.add(newCombo);
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
              value: selectedMenuItems.contains(menuItem),
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
        selectedMenuItems.remove(menuItem);
      } else {
        selectedMenuItems.add(menuItem);
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
}
