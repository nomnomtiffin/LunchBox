import 'package:flutter/material.dart';
import 'package:lunch_box/model/combo.dart';
import 'package:lunch_box/model/menu.dart';
import 'package:lunch_box/model/menu_item.dart';
import 'package:lunch_box/util/dummy_menu.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedMenuItems = widget.selectedCombo.comboItems;
    _comboName = widget.selectedCombo.comboName;
    _comboPrice = widget.selectedCombo.comboPrice;
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

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _selectedMenuItems.sort((a, b) => a.order.compareTo(b.order));
      Combo newCombo = Combo(
          comboName: _comboName,
          comboPrice: _comboPrice,
          comboItems: _selectedMenuItems);
      Menu? menuByDate = DummyMenu.getMenuByDate(widget.selectedDate);
      if (menuByDate == null) {
        List<Combo> combos = [newCombo];
        menuByDate = Menu(
            menuDate: widget.selectedDate,
            menuItems: List.empty(growable: true),
            combos: combos);
      } else {
        var combos = menuByDate.combos;
        for (Combo combo in combos) {
          if (combo.comboName == widget.selectedCombo.comboName) {
            combos.remove(combo);
            combos.add(newCombo);
            break;
          }
        }
      }
      DummyMenu.setMenuByDate(widget.selectedDate, menuByDate);
      Navigator.pop(context);
    }
  }

  List<Widget> getAllItems() {
    List<Row> rows = List.empty(growable: true);
    for (MenuItem menuItem in DummyMenu.getAllMenu()) {
      rows.add(Row(
        children: [
          Checkbox(
              value: _selectedMenuItems.contains(menuItem),
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
        _selectedMenuItems.remove(menuItem);
      } else {
        _selectedMenuItems.add(menuItem);
      }
    });
  }
}
