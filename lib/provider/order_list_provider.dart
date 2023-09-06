import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lunch_box/model/app_order.dart';

class OrderListNotifier extends StateNotifier<List<AppOrder>> {
  OrderListNotifier() : super([]);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void saveOrder(String status, String firestoreId, AppOrder input) {
    AppOrder order =
        input.copyWith(status: status, lastUpdatedDateTime: DateTime.now());
    _firestore
        .collection("app_order")
        .doc(firestoreId)
        .set(order.toJson())
        .then((value) => {});
  }

  Future<List<AppOrder>> loadOrders(DateTime menuDate) async {
    QuerySnapshot snapshot = await _firestore
        .collection("app_order")
        .where("phoneNumber", isNull: false)
        .where("menuDate", isEqualTo: DateFormat("d-MMM-yyyy").format(menuDate))
        .orderBy("phoneNumber")
        .get();

    final allData = snapshot.docs.map((doc) => doc.data()!).toList();
    if (allData.isNotEmpty) {
      List<AppOrder> orders = [];
      for (var order in allData) {
        AppOrder orderValue = AppOrder.fromJson(order as Map<String, dynamic>);
        if (orderValue.status == "OrderComplete") {
          orders.add(orderValue);
        }
      }
      state = orders;
    }
    return state;
  }
}

final orderListProvider =
    StateNotifierProvider<OrderListNotifier, List<AppOrder>>((ref) {
  return OrderListNotifier();
});
