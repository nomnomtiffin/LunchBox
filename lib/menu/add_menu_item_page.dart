import 'package:flutter/material.dart';
import 'package:lunch_box/model/menu_item.dart';
import 'package:lunch_box/provider/menu_factory.dart';

class AddMenuItemPage extends StatefulWidget {
  const AddMenuItemPage({Key? key}) : super(key: key);

  @override
  State<AddMenuItemPage> createState() => _AddMenuItemPageState();
}

class _AddMenuItemPageState extends State<AddMenuItemPage> {
  final _formKey = GlobalKey<FormState>();
  var _itemName = '';
  int _itemPrice = 0;
  var _selectedType = MenuFactory.getCategories()[0];

  @override
  Widget build(BuildContext context) {
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
                  items: MenuFactory.getCategories()
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
                      child: const Text('Add Item'),
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

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      List<MenuItem> menuItems = List.empty(growable: true);
      menuItems = await MenuFactory.getAllMenu();
      int count = 0;
      if (!menuItems.isEmpty) {
        count = menuItems.length + 1;
      }

      MenuItem newMenuItem = MenuItem(
          id: count,
          name: _itemName,
          type: _selectedType,
          price: _itemPrice,
          order: 0);
      menuItems.add(newMenuItem);
      MenuFactory.setMenuItem(menuItems);
      Navigator.pop(context);
    }
  }
}
