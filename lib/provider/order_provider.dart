import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/model/order.dart';

class OrderNotifier extends StateNotifier<Order> {
  OrderNotifier()
      : super(Order(
          selectedMenuItem: {},
          selectedCustomMenu: [],
          customThaliPrice: 0,
          totalCount: 0,
          totalPrice: 0,
          totalAfterTax: 0,
        ));

  double _getItemCount(Map<String, double> newselectedMenuItem) {
    double count = 0;

    for (String item in newselectedMenuItem.keys) {
      if (newselectedMenuItem[item] != null && newselectedMenuItem[item]! > 0) {
        count += newselectedMenuItem[item]!;
      }
    }
    return count;
  }

  void setSelectedMenuItem(
      String comboName, double count, double price, bool add) {
    Map<String, double> newselectedMenuItem = {
      ...state.selectedMenuItem,
      comboName: count
    };
    double totalCount = _getItemCount(newselectedMenuItem);
    double totalCost = state.totalPrice;
    double totalAfterTax = 0;
    if (add) {
      totalCost += price;
    } else {
      totalCost -= price;
    }
    totalAfterTax = totalCost + (state.tax / 100) * totalCost;
    totalAfterTax = double.parse(totalAfterTax.toStringAsFixed(2));
    state = state.copyWith(
        selectedMenuItem: newselectedMenuItem,
        totalCount: totalCount,
        totalPrice: totalCost,
        totalAfterTax: totalAfterTax);
  }

  void setSelectedCustomMenuAndPrice(String name, int price, bool addItem) {
    if (addItem) {
      List<String> newSelectedCustomMenu = [...state.selectedCustomMenu, name];
      double updatedPrice = state.customThaliPrice + price;
      state = state.copyWith(
          selectedCustomMenu: newSelectedCustomMenu,
          customThaliPrice: updatedPrice);
    } else {
      List<String> newSelectedCustomMenu = [...state.selectedCustomMenu];
      newSelectedCustomMenu.remove(name);
      double updatedPrice = state.customThaliPrice - price;
      state = state.copyWith(
          selectedCustomMenu: newSelectedCustomMenu,
          customThaliPrice: updatedPrice);
    }
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, Order>((ref) {
  return OrderNotifier();
});
