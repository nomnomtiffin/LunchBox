import 'package:flutter/material.dart';
import 'package:lunch_box/model/ingredient.dart';
import 'package:lunch_box/model/menu_item.dart';
import 'package:lunch_box/provider/menu_factory.dart';
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
  List<Ingredient> ingredients = [];
  List<Ingredient> selectedIng = [];
  List<Ingredient> searchedIng = [];
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    MenuFactory.getIngredients().then((value) {
      setState(() {
        ingredients = List.from(value);
        _selectedType = widget.selectedMenuItem.type;
        selectedIng = List.from(widget.selectedMenuItem.ingredients);
        ingredients =
            ingredients.where((ing) => !selectedIng.contains(ing)).toList();
        searchedIng = List.from(ingredients);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Menu Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(
                height: 5,
              ),
              const Text("Selected Ingredients"),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Row(
                        key: ValueKey(selectedIng[index].id),
                        children: [
                          Text(selectedIng[index].name),
                          const Spacer(),
                          SizedBox(
                            width: 100,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              initialValue:
                                  selectedIng[index].quantity.toString(),
                              decoration: const InputDecoration(
                                label: Text('Qt'),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    double.tryParse(value) == null ||
                                    double.tryParse(value)! <= 0) {
                                  return 'Must be a valid, positive number.';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                setState(() {
                                  selectedIng[index] = selectedIng[index]
                                      .copyWith(
                                          quantity: double.parse(newValue!));
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                              width: 50, child: Text(selectedIng[index].type)),
                          const SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                ingredients.add(selectedIng[index]);
                                selectedIng.remove(selectedIng[index]);
                                _runFilter(_searchKeyword);
                              });
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: const CircleBorder(),
                            ),
                          )
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: selectedIng.length),
              ),
              const Divider(
                thickness: 5,
              ),
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  hintText: 'Search Ingredients',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _runFilter(value),
              ),
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Row(
                        key: ValueKey(searchedIng[index].id),
                        children: [
                          Text(searchedIng[index].name),
                          const Spacer(),
                          Text(searchedIng[index].type),
                          const SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedIng.add(searchedIng[index]);
                                ingredients.remove(searchedIng[index]);
                                _runFilter(_searchKeyword);
                              });
                            },
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: const CircleBorder(),
                            ),
                          )
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: searchedIng.length),
              ),
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
                      child: const Text('Update Item'),
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
      List<MenuItem> updatedMenuItems = [];
      List<MenuItem> menuItems = await MenuFactory.getAllMenu();
      for (MenuItem menuItem in menuItems) {
        if (widget.selectedMenuItem.id == menuItem.id) {
          MenuItem updatedMenuItem = MenuItem(
              id: menuItem.id,
              name: _itemName,
              type: _selectedType,
              price: _itemPrice,
              order: menuItem.order,
              ingredients: selectedIng);
          updatedMenuItems.add(updatedMenuItem);
        } else {
          updatedMenuItems.add(menuItem);
        }
      }
      MenuFactory.setMenuItem(updatedMenuItems);
      Navigator.pop(context);
    }
  }

  _runFilter(String searchKeyword) {
    List<Ingredient> result = [];
    if (searchKeyword.isEmpty) {
      result = ingredients;
    } else {
      result = ingredients
          .where((ing) =>
              ing.name.toLowerCase().contains(searchKeyword.toLowerCase()))
          .toList();
    }
    result.sort((a, b) => a.id.compareTo(b.id));
    setState(() {
      _searchKeyword = searchKeyword;
      searchedIng = result;
    });
  }
}
