import 'package:flutter/material.dart';
import 'package:lunch_box/model/menu_item.dart';
import 'package:lunch_box/util/dummy_menu.dart';

class EditMenuItemPage extends StatefulWidget {
  const EditMenuItemPage(this.selectedMenuItem, {Key? key}) : super(key: key);
  final MenuItem selectedMenuItem;

  @override
  State<EditMenuItemPage> createState() => _EditMenuItemPageState();
}

class _EditMenuItemPageState extends State<EditMenuItemPage> {
  final _formKey = GlobalKey<FormState>();
  var _itemName = '';
  int _itemPrice = 0;
  var _selectedType = DummyMenu.getCategories()[0];

  @override
  Widget build(BuildContext context) {
    _selectedType = widget.selectedMenuItem.type;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Menu Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                initialValue: widget.selectedMenuItem.name,
                decoration: const InputDecoration(
                  label: Text('Item Name'),
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
                  _itemName = value!;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: widget.selectedMenuItem.price.toString(),
                decoration: const InputDecoration(
                  label: Text('Item Price'),
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
                  _itemPrice = int.parse(value!);
                },
              ),
              DropdownButtonFormField(
                  items: DummyMenu.getCategories()
                      .map((category) => DropdownMenuItem(
                            child: Text(category),
                            value: category,
                          ))
                      .toList(),
                  onChanged: (value) {
                    _selectedType = value as String;
                  },
                  value: _selectedType),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
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
                      child: const Text('Edit Item'),
                    )
                  ],
                ),
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
      List<MenuItem> updatedMenuItems = [];
      for (MenuItem menuItem in DummyMenu.getAllMenu()) {
        if (widget.selectedMenuItem.id == menuItem.id) {
          MenuItem updatedMenuItem = MenuItem(
              id: menuItem.id,
              name: _itemName,
              type: _selectedType,
              price: _itemPrice,
              order: menuItem.order);
          updatedMenuItems.add(updatedMenuItem);
        } else {
          updatedMenuItems.add(menuItem);
        }
      }
      DummyMenu.setMenuItem(updatedMenuItems);
      Navigator.pop(context);
    }
  }
}
