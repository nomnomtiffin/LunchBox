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

class AdminOrderSummaryPage extends ConsumerStatefulWidget {
  const AdminOrderSummaryPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminOrderSummaryPage> createState() =>
      _AdminOrderSummaryPageState();
}

class _AdminOrderSummaryPageState extends ConsumerState<AdminOrderSummaryPage> {
  bool isLoading = false;
  List<AppOrder> orders = [];
  Map<String, double> comboMap = {};
  Map<Ingredient, double> ingredientMap = {};
  Map<String, double> menuItemCount = {};

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getData();
  }

  void getData() async {
    var orderListNotifier = ref.read(orderListProvider.notifier);
    List<AppOrder> orderList =
        await orderListNotifier.loadOrders(DateTime(2023, 6, 30));
    //TODO replace the hardcoded date with dynamic date
    var menuNotifier = ref.read(menuProvider.notifier);
    await menuNotifier.getMenu();
    Menu menu = ref.read(menuProvider);
    Map<String, Combo> combos = {};
    for (Combo combo in menu.combos) {
      combos[combo.comboName] = combo;
    }
    for (AppOrder order in orderList) {
      for (MapEntry<String, double> combo in order.selectedMenuItem.entries) {
        if (combo.key == AppConstants.CUSTOM_THALI) {
          double count = comboMap[AppConstants.CUSTOM_THALI] ?? 0;
          comboMap[AppConstants.CUSTOM_THALI] = count + combo.value;

          for (String menuItemName in order.selectedCustomMenu) {
            double mCount = menuItemCount[menuItemName] ?? 0;
            menuItemCount[menuItemName] = mCount + combo.value;
          }
        } else {
          double count = comboMap[combo.key] ?? 0;
          comboMap[combo.key] = count + combo.value;
          Combo comboValue = combos[combo.key]!;
          for (MenuItem menuItem in comboValue.comboItems) {
            double mCount = menuItemCount[menuItem.name] ?? 0;
            menuItemCount[menuItem.name] = mCount + combo.value;
          }
        }
      }
    }
    setState(() {
      isLoading = false;
      orders = orderList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      body: isLoading
          ? const SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : orders.isEmpty
              ? const SafeArea(
                  child: Center(
                  child: Text("No orders Available!"),
                ))
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [...getSummary()],
                    ),
                  ),
                ),
    );
  }

  List<Widget> getSummary() {
    List<Widget> widgets = [];
    for (MapEntry<String, double> combo in comboMap.entries) {
      widgets.add(Row(
        children: [
          Text(combo.key),
          const Spacer(),
          Text(combo.value.toString()),
        ],
      ));
    }

    widgets.add(const Divider());

    for (MapEntry<String, double> menuItems in menuItemCount.entries) {
      widgets.add(Row(
        children: [
          Text(menuItems.key),
          const Spacer(),
          Text(menuItems.value.toString()),
        ],
      ));
    }

    return widgets;
  }
}
