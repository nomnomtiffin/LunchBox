import 'package:flutter/material.dart';
import 'package:lunch_box/menu/add_ingredient_page.dart';
import 'package:lunch_box/model/ingredient.dart';
import 'package:lunch_box/provider/menu_factory.dart';

class DisplayIngredientsPage extends StatefulWidget {
  const DisplayIngredientsPage({Key? key}) : super(key: key);

  @override
  State<DisplayIngredientsPage> createState() => _DisplayIngredientsPageState();
}

class _DisplayIngredientsPageState extends State<DisplayIngredientsPage> {
  List<Ingredient> _ingredients = [];

  @override
  void initState() {
    super.initState();
    MenuFactory.getIngredients().then((value) => setState(() {
          _ingredients = List.from(value);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ingredients"),
        actions: [
          TextButton(
            child: const Text('Add Item'),
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).secondaryHeaderColor),
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) =>
                      AddIngredientPage(_ingredients))); //_ingredients
              setState(() {
                MenuFactory.getIngredients()
                    .then((value) => _ingredients = List.from(value));
              });
            },
          ),
        ],
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              key: ValueKey(_ingredients[index].id),
              title: Text(_ingredients[index].name),
              subtitle: _ingredients[index].bulk
                  ? Text(_ingredients[index].type + " | Bulk")
                  : Text(_ingredients[index].type),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: _ingredients.length),
    );
  }
}
