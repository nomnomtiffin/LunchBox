import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/model/cooking_expense.dart';
import 'package:lunch_box/model/ingredient.dart';
import 'package:lunch_box/provider/auth_provider.dart';
import 'package:lunch_box/provider/cooking_expense_provider.dart';

class AddInventoryPage extends ConsumerStatefulWidget {
  const AddInventoryPage(this.ingredient, {Key? key}) : super(key: key);
  final Ingredient ingredient;
  @override
  ConsumerState<AddInventoryPage> createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends ConsumerState<AddInventoryPage> {
  final _formKey = GlobalKey<FormState>();
  double price = 0;
  double quantity = 0;
  String selectedType = '';

  @override
  void initState() {
    if (widget.ingredient.type == "g" || widget.ingredient.type == "kg") {
      selectedType = "kg";
    } else if (widget.ingredient.type == "ml" ||
        widget.ingredient.type == "l") {
      selectedType = "l";
    } else if (widget.ingredient.type == "count") {
      selectedType = "count";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bulk Inventory"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(widget.ingredient.name),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    label: Text('Price'),
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
                  onSaved: (value) {
                    price = double.parse(value!);
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: const Text('Quantity'),
                    suffix: Text(selectedType),
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
                  onSaved: (value) {
                    quantity = double.parse(value!);
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
                        child: const Text('Add Item'),
                      )
                    ],
                  ),
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

      double ingQuantity = quantity;
      if (widget.ingredient.type != selectedType) {
        if (widget.ingredient.type == "g" && selectedType == "kg") {
          ingQuantity = quantity * 1000;
        } else if (widget.ingredient.type == "ml" && selectedType == "l") {
          ingQuantity = quantity * 1000;
        }
      }
      double perUnitPrice = price / ingQuantity;
      perUnitPrice = double.parse(perUnitPrice.toStringAsFixed(2));

      ref.read(cookingExpenseProvider.notifier).setCookingExpense(
          CookingExpense(
              ingredientId: widget.ingredient.id,
              quantityBought: ingQuantity,
              quantityRemaining: ingQuantity,
              price: price,
              perUnitPrice: perUnitPrice,
              purchaseDate: DateTime.now(),
              fireStoreId: "",
              boughtBy: ref.read(authProvider).phoneNumber));
      Navigator.pop(context);
    }
  }
}
