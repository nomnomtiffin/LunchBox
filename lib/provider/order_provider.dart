import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lunch_box/model/app_address.dart';
import 'package:lunch_box/model/app_coupon.dart';
import 'package:lunch_box/model/app_order.dart';
import 'package:lunch_box/model/app_user.dart';

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
      bool add, DateTime menuDate, AppUser appUser) async {
    await setCoupon(appUser, null);
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
    double totalCostAfterDiscount = 0;
    if (state.couponApplied != null) {
      if (state.couponApplied!.isAmount) {
        double discountAmount = state.couponApplied!.discountAmount!;
        if (discountAmount > totalCost) {
          totalCostAfterDiscount = 0.0;
        } else {
          totalCostAfterDiscount = totalCost - discountAmount;
        }
      } else {
        totalCostAfterDiscount = totalCost -
            (state.couponApplied!.discountPercentage! / 100) * totalCost;
        totalCostAfterDiscount =
            double.parse(totalCostAfterDiscount.toStringAsFixed(2));
      }
    } else {
      totalCostAfterDiscount = totalCost;
    }
    totalAfterTax =
        totalCostAfterDiscount + (state.tax / 100) * totalCostAfterDiscount;
    totalAfterTax = double.parse(totalAfterTax.toStringAsFixed(2));
    state = state.copyWith(
        selectedMenuItem: newselectedMenuItem,
        totalCount: totalCount,
        totalPrice: totalCost,
        totalAfterTax: totalAfterTax,
        menuDate: DateFormat("d-MMM-yyyy").format(menuDate));
  }

  void setSelectedCustomMenuAndPrice(String name, int price, bool addItem,
      DateTime menuDate, AppUser appUser) {
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

  void firstTimeSaveWithUid(String status, String phoneNumber, String uId) {
    AppOrder order = state.copyWith(
        status: status,
        lastUpdatedDateTime: DateTime.now(),
        phoneNumber: phoneNumber,
        uId: uId);
    state = order;
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
    state = order;
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

  Future<void> updateCouponSignOut(AppUser appUser,
      {required BuildContext context}) async {
    await updateCoupon(appUser, null);
  }

  Future<void> updateCoupon(AppUser appUser, AppCoupon? newCoupon) async {
    state = state.copyWith(
        couponApplied: AppCoupon(
            fireStoreId: "dummy",
            count: 0,
            redeemCount: 0,
            startDate: DateTime.now(),
            endDate: DateTime.now(),
            isAmount: false,
            available: false));
    await setCoupon(appUser, newCoupon);
    double totalCost = state.totalPrice;
    double totalCostAfterDiscount = 0;
    double totalAfterTax = 0;
    if (state.couponApplied != null) {
      if (state.couponApplied!.isAmount) {
        double discountAmount = state.couponApplied!.discountAmount!;
        if (discountAmount > totalCost) {
          totalCostAfterDiscount = 0.0;
        } else {
          totalCostAfterDiscount = totalCost - discountAmount;
        }
      } else {
        totalCostAfterDiscount = totalCost -
            (state.couponApplied!.discountPercentage! / 100) * totalCost;
        totalCostAfterDiscount =
            double.parse(totalCostAfterDiscount.toStringAsFixed(2));
      }
    } else {
      totalCostAfterDiscount = totalCost;
    }
    totalAfterTax =
        totalCostAfterDiscount + (state.tax / 100) * totalCostAfterDiscount;
    totalAfterTax = double.parse(totalAfterTax.toStringAsFixed(2));
    state = state.copyWith(totalPrice: totalCost, totalAfterTax: totalAfterTax);
  }

  Future<void> setCoupon(AppUser appUser, AppCoupon? newCoupon) async {
    if (newCoupon != null) {
      state = state.copyWith(couponApplied: newCoupon);
    } else {
      //find the best coupon and apply that
      if (state.couponApplied == null ||
          state.couponApplied!.endDate.isBefore(DateTime.now())) {
        List<AppCoupon> coupons = await loadCoupons(appUser);
        if (coupons.isNotEmpty) {
          state = state.copyWith(couponApplied: coupons.first);
        } else {
          state = state.copyWith(
              couponApplied: AppCoupon(
                  fireStoreId: "dummy",
                  count: 0,
                  redeemCount: 0,
                  startDate: DateTime.now(),
                  endDate: DateTime.now(),
                  isAmount: false,
                  available: false));
        }
      }
    }
  }

  Future<List<AppCoupon>> loadCoupons(AppUser appUser) async {
    List<AppCoupon> couponList = [];
    QuerySnapshot snapshot = await _firestore
        .collection("app_coupon")
        .where("uId", isNull: true)
        .where("available", isEqualTo: true)
        .get();
    final allData = snapshot.docs.map((doc) => doc.data()!).toList();
    if (allData.isNotEmpty) {
      couponList = allData
          .map((e) => AppCoupon.fromJson(e as Map<String, dynamic>))
          .toList();
      couponList = couponList
          .where((element) => element.endDate.isAfter(DateTime.now()))
          .toList(growable: true);
    } else {
      couponList = List.empty(growable: true);
    }
    if (appUser.isSigned) {
      List<AppCoupon> userCouponList = [];
      QuerySnapshot userSnapshot = await _firestore
          .collection("app_coupon")
          .where("uId", isEqualTo: appUser.uId)
          .where("available", isEqualTo: true)
          .get();
      final allUserData = userSnapshot.docs.map((doc) => doc.data()!).toList();
      if (allUserData.isNotEmpty) {
        userCouponList = allUserData
            .map((e) => AppCoupon.fromJson(e as Map<String, dynamic>))
            .toList();
        userCouponList = userCouponList
            .where((element) => element.endDate.isAfter(DateTime.now()))
            .toList(growable: true);
        if (userCouponList.isNotEmpty) {
          couponList.addAll(userCouponList);
        }
      }
    }
    couponList.sort((a, b) => a.endDate.compareTo(b.endDate));
    return couponList;
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, AppOrder>((ref) {
  return OrderNotifier();
});
