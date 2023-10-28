import 'package:flutter/material.dart';
import 'package:lunch_box/menu/add_category_page.dart';
import 'package:lunch_box/menu/edit_categories_page.dart';
import 'package:lunch_box/provider/menu_factory.dart';

class DisplayCategoriesPage extends StatefulWidget {
  const DisplayCategoriesPage({Key? key}) : super(key: key);

  @override
  State<DisplayCategoriesPage> createState() => _DisplayCategoriesPageState();
}

class _DisplayCategoriesPageState extends State<DisplayCategoriesPage> {
  List<String> _categories = [];
  List<String> _selectedCategories = [];
  @override
  Widget build(BuildContext context) {
    MenuFactory.getCategories().then((value) => {
          setState(() {
            _categories = List.from(value);
          })
        });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        actions: [
          TextButton(
            child: const Text('Add Item'),
            onPressed: () async {
              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const AddCategoryPage()));
              setState(() {
                MenuFactory.getCategories()
                    .then((value) => _categories = List.from(value));
              });
            },
          ),
          TextButton(
            child: const Text('Edit Item'),
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).secondaryHeaderColor),
            onPressed: () async {
              if (_selectedCategories.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please select a item to edit!")));
              } else if (_selectedCategories.length > 1) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please select only one item to edit!")));
              } else {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) =>
                        EditCategoriesPage(_selectedCategories[0])));
                setState(() {
                  _selectedCategories = [];
                  MenuFactory.getAllMenu()
                      .then((value) => _categories = List.from(value));
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          for (String category in _categories)
            ListTile(
              key: ValueKey(category),
              title: Row(
                children: [
                  Checkbox(
                    value: _selectedCategories.contains(category),
                    onChanged: (value) => {
                      setState(() {
                        if (value == null || value == false) {
                          _selectedCategories.remove(category);
                        } else {
                          _selectedCategories.add(category);
                        }
                      })
                    },
                  ),
                  Text(category),
                ],
              ),
            )
        ],
      ),
    );
  }
}
