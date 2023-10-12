import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lunch_box/model/app_order.dart';

class SearchOrderNotifier extends StateNotifier<List<AppOrder>> {
  SearchOrderNotifier() : super([]);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AppOrder>> loadOrder(String phoneNo, DateTime menuDate) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection("app_order")
        .where("phoneNumber", isEqualTo: phoneNo)
        .where("menuDate", isEqualTo: DateFormat("d-MMM-yyyy").format(menuDate))
        .get();
    final allData = snapshot.docs.map((doc) => doc.data()!).toList();
    if (allData.isNotEmpty) {
      state = allData.map((order) => AppOrder.fromJson(order)).toList();
    } else {
      state = [];
    }
    return state;
  }

  Future<void> cancelOrder(String feedback, AppOrder selectedOrder) async {
    AppOrder order = selectedOrder.copyWith(
        status: "Cancelled",
        feedback: feedback,
        lastUpdatedDateTime: DateTime.now());
    await _firestore
        .collection("app_order")
        .doc(order.fireStoreId)
        .set(order.toJson());
  }
}

final searchOrderProvider =
    StateNotifierProvider<SearchOrderNotifier, List<AppOrder>>(
        (ref) => SearchOrderNotifier());
