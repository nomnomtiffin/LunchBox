import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/model/app_order.dart';
import 'package:lunch_box/model/combo.dart';
import 'package:lunch_box/model/ingredient.dart';
import 'package:lunch_box/model/menu.dart';
import 'package:lunch_box/model/menu_item.dart';
import 'package:lunch_box/provider/menu_provider.dart';
import 'package:lunch_box/provider/order_list_provider.dart';
import 'package:lunch_box/util/AppConstants.dart';

import '../model/shopping_item.dart';
import '../util/utils.dart';

class AdminShoppingListPage extends ConsumerStatefulWidget {
  const AdminShoppingListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminShoppingListPage> createState() =>
      _AdminShoppingListPageState();
}

class _AdminShoppingListPageState extends ConsumerState<AdminShoppingListPage> {
  bool isLoading = false;
  List<AppOrder> orders = [];
  Map<String, double> comboMap = {};
  Map<int, double> ingredientMap = {};
  Map<String, double> menuItemCount = {};
  DateTime selectedDate = DateTime(2023);
  List<ShoppingItem> shoppingItems = [];

  @override
  void initState() {
    super.initState();
    //TODO replace the hardcoded date with DateTime.now
    DateTime currentDate = DateTime(2023, 6, 30);
    setState(() {
      selectedDate = currentDate;
      isLoading = true;
    });
    getData(currentDate);
  }

  void getData(DateTime currentDate) async {
    var orderListNotifier = ref.read(orderListProvider.notifier);
    List<AppOrder> orderList = await orderListNotifier.loadOrders(currentDate);

    comboMap = {};
    ingredientMap = {};
    menuItemCount = {};
    var menuNotifier = ref.read(menuProvider.notifier);
    await menuNotifier.getMenu();
    Menu menu = ref.read(menuProvider);
    Map<int, Ingredient> ingredientsIdMap = {};
    Map<String, Combo> combos = {};
    for (Combo combo in menu.combos) {
      combos[combo.comboName] = combo;
    }
    Map<String, MenuItem> menuItemMap = {};
    for (MenuItem menuItem in menu.menuItems) {
      menuItemMap[menuItem.name] = menuItem;
    }
    for (AppOrder order in orderList) {
      for (MapEntry<String, double> combo in order.selectedMenuItem.entries) {
        if (combo.key == AppConstants.CUSTOM_THALI) {
          double count = comboMap[AppConstants.CUSTOM_THALI] ?? 0;
          comboMap[AppConstants.CUSTOM_THALI] = count + combo.value;

          for (String menuItemName in order.selectedCustomMenu) {
            double mCount = menuItemCount[menuItemName] ?? 0;
            menuItemCount[menuItemName] = mCount + combo.value;
            for (Ingredient ingredient
                in menuItemMap[menuItemName]!.ingredients) {
              double mCount = ingredientMap[ingredient.id] ?? 0;
              ingredientMap[ingredient.id] =
                  mCount + (ingredient.quantity * combo.value);
              ingredientsIdMap[ingredient.id] = ingredient;
            }
          }
        } else {
          double count = comboMap[combo.key] ?? 0;
          comboMap[combo.key] = count + combo.value;
          Combo comboValue = combos[combo.key]!;
          for (MenuItem menuItem in comboValue.comboItems) {
            double mCount = menuItemCount[menuItem.name] ?? 0;
            menuItemCount[menuItem.name] = mCount + combo.value;
            for (Ingredient ingredient in menuItem.ingredients) {
              double iCount = ingredientMap[ingredient.id] ?? 0;
              ingredientMap[ingredient.id] =
                  iCount + (ingredient.quantity * combo.value);
              ingredientsIdMap[ingredient.id] = ingredient;
            }
          }
        }
      }
    }
    int count = 0;
    shoppingItems = [];
    for (MapEntry<int, double> i in ingredientMap.entries) {
      ShoppingItem shoppingItem =
          ShoppingItem(count++, ingredientsIdMap[i.key]!, i.value, 0);
      shoppingItems.add(shoppingItem);
    }
    setState(() {
      isLoading = false;
      orders = orderList;
      selectedDate = currentDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping List"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}    '),
                  ElevatedButton(
                    onPressed: changeDate,
                    child: const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            isLoading
                ? const SafeArea(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : shoppingItems.isEmpty
                    ? const SafeArea(
                        child: Center(
                        child: Text("No shopping list available!"),
                      ))
                    : Expanded(
                        child: ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            //See the example of list view then start
                            return Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(shoppingItems[index]
                                                .ingredient
                                                .name),
                                            Text(
                                              roundIngValue(
                                                  shoppingItems[index]
                                                      .ingredient,
                                                  shoppingItems[index]
                                                      .totalQuantity),
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Theme.of(context)
                                                      .disabledColor),
                                            ),
                                          ]),
                                      const Spacer(),
                                      Text('₹ ' +
                                          shoppingItems[index]
                                              .price
                                              .toString() +
                                          '   '),
                                      IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  SimpleDialog(
                                                title:
                                                    const Text("Enter price"),
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextField(
                                                      controller:
                                                          TextEditingController()
                                                            ..text =
                                                                'To be implemented',
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Spacer(
                                                        flex: 4,
                                                      ),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              "Update")),
                                                      const Spacer(
                                                        flex: 1,
                                                      ),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              "Cancel")),
                                                      const Spacer(
                                                        flex: 4,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.edit))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                          itemCount: orders.length,
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  void changeDate() async {
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2022),
        lastDate: DateTime.now());
    if (newDate == null) return;
    setState(() {
      selectedDate = newDate;
      isLoading = true;
    });
    getData(newDate);
  }
}
