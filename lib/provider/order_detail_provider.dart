import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/model/app_address.dart';
import 'package:lunch_box/model/app_coupon.dart';
import 'package:lunch_box/model/app_order.dart';

class OrderDetailNotifier extends StateNotifier<AppOrder> {
  OrderDetailNotifier()
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

  void loadOrder(String fireStoreId) {
    _firestore.collection("app_order").doc(fireStoreId).get().then((value) => {
          if (value.exists)
            {state = AppOrder.fromJson(value.data() as Map<String, dynamic>)}
          else
            {state = AppOrder.initial().copyWith(status: 'No order found')}
        });
  }

  void setOrder(AppOrder order) {
    state = order;
  }

  Future<void> cancelOrder(AppOrder selectedOrder, String userFeedback) async {
    AppOrder order = selectedOrder.copyWith(
        status: "Cancelled",
        lastUpdatedDateTime: DateTime.now(),
        feedback: userFeedback);
    await _firestore
        .collection("app_order")
        .doc(order.fireStoreId)
        .set(order.toJson());
    AppCoupon appCoupon = AppCoupon(
        fireStoreId: "",
        count: 1,
        redeemCount: 0,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 30)).copyWith(
              hour: 0,
              minute: 0,
              second: 0,
              millisecond: 0,
              microsecond: 0,
            ),
        isAmount: true,
        discountAmount: order.totalAfterTax,
        uId: order.uId,
        available: true);
    DocumentReference<Map<String, dynamic>> documentReference =
        await _firestore.collection("app_coupon").add(appCoupon.toJson());
    await documentReference.update({"fireStoreId": documentReference.id});
    state = order;
  }
}

final orderDetailProvider =
    StateNotifierProvider<OrderDetailNotifier, AppOrder>(
        (ref) => OrderDetailNotifier());
