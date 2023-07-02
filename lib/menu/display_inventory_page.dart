import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/menu/add_inventory_page.dart';
import 'package:lunch_box/model/cooking_expense.dart';
import 'package:lunch_box/model/ingredient.dart';
import 'package:lunch_box/provider/cooking_expense_provider.dart';
import 'package:lunch_box/provider/menu_factory.dart';

import '../util/utils.dart';

class DisplayInventoryPage extends ConsumerStatefulWidget {
  const DisplayInventoryPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DisplayInventoryPage> createState() =>
      _DisplayInventoryPageState();
}

class _DisplayInventoryPageState extends ConsumerState<DisplayInventoryPage> {
  List<Ingredient> _ingredients = [];
  List<CookingExpense> _cookingExpenses = [];
  List<String> _ingredientsQuantity = [];

  @override
  void initState() {
    super.initState();
    populateInventory();
  }

  void populateInventory() {
    MenuFactory.getIngredients().then((value) async {
      List<Ingredient> ingredients =
          List.from(value.where((ing) => ing.bulk).toList());
      ingredients.sort(
        (a, b) => a.id.compareTo(b.id),
      );
      //get cooking Expenses to get the remaining quantity for each ingredients
      List<CookingExpense> cookingExpenses = await ref
          .read(cookingExpenseProvider.notifier)
          .getCookingExpense(ingredients.map((e) => e.id).toList());
      List<String> ingredientsQuantity = [];
      //loop through cookingExpenses for each ingredients to get the remaining quantity for each ingredients
      for (Ingredient ing in ingredients) {
        String ingQuantity = '';
        double totalRemainingQuantity = 0;
        for (CookingExpense expense in cookingExpenses) {
          if (expense.ingredientId == ing.id) {
            //if we have multiple expenses we will show as 1+10=11
            if (ingQuantity.isNotEmpty) {
              ingQuantity += " + ";
            }
            ingQuantity += roundIngValue(ing, expense.quantityRemaining);
            totalRemainingQuantity += expense.quantityRemaining;
          }
        }
        if (ingQuantity.isNotEmpty) {
          String roundedValue = roundIngValue(ing, totalRemainingQuantity);
          if (ingQuantity.contains("+")) {
            ingQuantity += " = " + roundedValue;
          } else {
            ingQuantity = roundedValue;
          }
        }
        ingredientsQuantity.add(ingQuantity);
      }
      setState(() {
        _ingredients = ingredients;
        _cookingExpenses = cookingExpenses;
        _ingredientsQuantity = ingredientsQuantity;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bulk Inventory"),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              key: ValueKey(_ingredients[index].id),
              title: Text(_ingredients[index].name),
              subtitle: Text(_ingredientsQuantity[index]),
              trailing: ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => AddInventoryPage(_ingredients[index])));
                  populateInventory();
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: const CircleBorder(),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: _ingredients.length),
    );
  }
}
