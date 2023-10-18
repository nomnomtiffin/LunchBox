import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lunch_box/model/app_coupon.dart';
import 'package:lunch_box/model/app_user.dart';
import 'package:lunch_box/provider/auth_provider.dart';
import 'package:lunch_box/provider/coupon_list_provider.dart';
import 'package:lunch_box/util/utils.dart';

class CouponListPage extends ConsumerStatefulWidget {
  const CouponListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CouponListPage> createState() => _CouponListPageState();
}

class _CouponListPageState extends ConsumerState<CouponListPage> {
  List<AppCoupon> coupons = [];
  String message = "Loading coupons...";

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    AppUser appUser = ref.read(authProvider);
    List<AppCoupon> loadCoupons =
        await ref.read(couponListProvider.notifier).loadCoupons(appUser);

    setState(() {
      coupons = loadCoupons;
      if (coupons.isEmpty) {
        message = "No Coupon available";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coupon"),
      ),
      body: SafeArea(
        child: coupons.isEmpty
            ? Column(
                children: [Text(message)],
              )
            : ListView.separated(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                    child: Card(
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(coupons[index].fireStoreId),
                              Text("Expire On " +
                                  DateFormat("d-MMM-yyyy")
                                      .format(coupons[index].endDate)),
                              Text(coupons[index].isAmount
                                  ? "Discount ₹ ${coupons[index].discountAmount}"
                                  : " Discount ${coupons[index].discountPercentage}%")
                            ],
                          ),
                          const Spacer(),
                          ElevatedButton(
                              onPressed: () async {
                                await Clipboard.setData(ClipboardData(
                                    text: coupons[index].fireStoreId));
                                showSnackBar(
                                    context, "Coupon copied to clipboard!");
                              },
                              child: const Text("Copy")),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
                itemCount: coupons.length,
              ),
      ),
    );
  }
}
