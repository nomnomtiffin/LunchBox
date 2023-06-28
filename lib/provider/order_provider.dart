import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lunch_box/model/app_address.dart';
import 'package:lunch_box/model/app_order.dart';

class OrderNotifier extends StateNotifier<AppOrder> {
  OrderNotifier()
      : super(AppOrder(
            selectedMenuItem: {},
            selectedCustomMenu: [],
            menuDate: '',
            customThaliPrice: 0,
            totalCount: 0,
            totalPrice: 0,
            totalAfterTax: 0,
            uId: '',
            phoneNumber: '',
            name: '',
            address: AppAddress(
                officeName: "", streetAddress: "", city: "", state: "", zip: 0),
            status: 'New',
            createDateTime: DateTime.now(),
            lastUpdatedDateTime: DateTime.now(),
            fireStoreId: ''));

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  double _getItemCount(Map<String, double> newselectedMenuItem) {
    double count = 0;

    for (String item in newselectedMenuItem.keys) {
      if (newselectedMenuItem[item] != null && newselectedMenuItem[item]! > 0) {
        count += newselectedMenuItem[item]!;
      }
    }
    return count;
  }

  void setSelectedMenuItem(String comboName, double count, double price,
      bool add, DateTime menuDate) {
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
        totalAfterTax: totalAfterTax,
        menuDate: DateFormat("d-MMM-yyyy").format(menuDate));
  }

  void setSelectedCustomMenuAndPrice(
      String name, int price, bool addItem, DateTime menuDate) {
    if (addItem) {
      List<String> newSelectedCustomMenu = [...state.selectedCustomMenu, name];
      double updatedPrice = state.customThaliPrice + price;
      state = state.copyWith(
          selectedCustomMenu: newSelectedCustomMenu,
          customThaliPrice: updatedPrice,
          menuDate: DateFormat("d-MMM-yyyy").format(menuDate));
    } else {
      List<String> newSelectedCustomMenu = [...state.selectedCustomMenu];
      newSelectedCustomMenu.remove(name);
      double updatedPrice = state.customThaliPrice - price;
      state = state.copyWith(
          selectedCustomMenu: newSelectedCustomMenu,
          customThaliPrice: updatedPrice);
    }
  }

  void firstTimeSave(String status) {
    AppOrder order =
        state.copyWith(status: status, lastUpdatedDateTime: DateTime.now());
    _firestore
        .collection("app_order")
        .add(order.toJson())
        .then((value) => {state = state.copyWith(fireStoreId: value.id)});
  }

  void saveOrder(
      String status, String firestoreId, String phoneNumber, String uId) {
    AppOrder order = state.copyWith(
        status: status,
        lastUpdatedDateTime: DateTime.now(),
        phoneNumber: phoneNumber,
        uId: uId);
    _firestore
        .collection("app_order")
        .doc(firestoreId)
        .set(order.toJson())
        .then((value) => {});
  }

  Future<void> saveDetail(
      String name, String phone, String status, AppAddress address) async {
    AppOrder order = state.copyWith(
        status: status,
        lastUpdatedDateTime: DateTime.now(),
        name: name,
        phoneNumber: phone,
        address: address);
    state = order;
    await _firestore
        .collection("app_order")
        .doc(state.fireStoreId)
        .set(order.toJson());
  }

  Future<void> paymentConfirmation() async {
    AppOrder order = state.copyWith(
        status: "OrderComplete", lastUpdatedDateTime: DateTime.now());
    await _firestore
        .collection("app_order")
        .doc(order.fireStoreId)
        .set(order.toJson());
    state = AppOrder(
        selectedMenuItem: {},
        selectedCustomMenu: [],
        menuDate: '',
        customThaliPrice: 0,
        totalCount: 0,
        totalPrice: 0,
        totalAfterTax: 0,
        uId: '',
        phoneNumber: '',
        name: '',
        address: AppAddress(
            officeName: "", streetAddress: "", city: "", state: "", zip: 0),
        status: 'New',
        createDateTime: DateTime.now(),
        lastUpdatedDateTime: DateTime.now(),
        fireStoreId: '');
  }

  void loadOngoingOrder(String uId, DateTime menuDate) {
    _firestore
        .collection("app_order")
        .where("uId", isEqualTo: uId)
        .where("status", isNotEqualTo: "OrderComplete")
        .where("menuDate", isEqualTo: DateFormat("d-MMM-yyyy").format(menuDate))
        .get()
        .then((value) => {
              if (value.size > 0)
                {
                  state = AppOrder.fromJson(
                      value.docs.first as Map<String, dynamic>)
                }
            });
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, AppOrder>((ref) {
  return OrderNotifier();
});
