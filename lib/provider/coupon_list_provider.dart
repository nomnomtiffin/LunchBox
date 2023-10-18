import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/model/app_coupon.dart';
import 'package:lunch_box/model/app_user.dart';

class CouponListNotifier extends StateNotifier<List<AppCoupon>> {
  CouponListNotifier() : super([]);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    state = couponList;
    return state;
  }
}

final couponListProvider =
    StateNotifierProvider<CouponListNotifier, List<AppCoupon>>((ref) {
  return CouponListNotifier();
});
