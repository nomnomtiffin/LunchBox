import 'package:flutter/material.dart';
import 'package:lunch_box/model/ingredient.dart';
import 'package:lunch_box/provider/menu_factory.dart';

class AddIngredientPage extends StatefulWidget {
  const AddIngredientPage(this.ingredients, {Key? key}) : super(key: key);
  final List<Ingredient> ingredients;
  @override
  State<AddIngredientPage> createState() => _AddIngredientPageState();
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  final _formKey = GlobalKey<FormState>();
  var _itemName = '';
  final List<String> quantityTypes = MenuFactory.quantityTypes;
  var _selectedQuantityType = '';

  @override
  void initState() {
    _selectedQuantityType = quantityTypes[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Ingredients"),
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
                  label: Text('Ingredient Name'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  if (widget.ingredients != null) {
                    List<Ingredient> result = widget.ingredients
                        .where((element) =>
                            element.name.toLowerCase() == value.toLowerCase())
                        .toList();
                    if (result.isNotEmpty) {
                      return 'Ingredient already present';
                    }
                  }
                  return null;
                },
                onSaved: (value) {
                  _itemName = value!;
                },
              ),
              DropdownButtonFormField(
                  items: quantityTypes
                      .map((category) => DropdownMenuItem(
                            child: Text(category),
                            value: category,
                          ))
                      .toList(),
                  onChanged: (value) {
                    _selectedQuantityType = value as String;
                  },
                  value: _selectedQuantityType),
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
      MenuFactory.setIngredient(Ingredient(
          widget.ingredients != null ? widget.ingredients.length : 0,
          _itemName,
          _selectedQuantityType,
          0));

      Navigator.pop(context);
    }
  }
}
