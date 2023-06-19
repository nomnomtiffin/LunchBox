import 'package:flutter/material.dart';
import 'package:lunch_box/provider/menu_factory.dart';

class EditCategoriesPage extends StatefulWidget {
  const EditCategoriesPage(this.selectedCategory, {Key? key}) : super(key: key);
  final String selectedCategory;

  @override
  State<EditCategoriesPage> createState() => _EditCategoriesPageState();
}

class _EditCategoriesPageState extends State<EditCategoriesPage> {
  final _formKey = GlobalKey<FormState>();
  var _categoryName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Category"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.selectedCategory,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Category'),
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
                  _categoryName = value!;
                },
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
                      child: const Text('Update Category'),
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
      List<String> categories = await MenuFactory.getCategories();
      categories.remove(widget.selectedCategory);
      categories.add(_categoryName);
      MenuFactory.setCategories(categories);
      Navigator.pop(context);
    }
  }
}
