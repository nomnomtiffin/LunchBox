import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lunch_box/model/app_coupon.dart';
import 'package:lunch_box/model/app_user.dart';
import 'package:lunch_box/provider/auth_provider.dart';
import 'package:lunch_box/provider/coupon_list_provider.dart';
import 'package:lunch_box/provider/order_provider.dart';
import 'package:lunch_box/util/AppConstants.dart';

class SelectCouponPage extends ConsumerStatefulWidget {
  const SelectCouponPage(this.currentCoupon, {Key? key}) : super(key: key);
  final AppCoupon currentCoupon;
  @override
  ConsumerState<SelectCouponPage> createState() => _SelectCouponPageState();
}

class _SelectCouponPageState extends ConsumerState<SelectCouponPage> {
  List<AppCoupon> coupons = [];
  String message = "Loading coupons...";
  late AppCoupon selectedCoupon;

  @override
  void initState() {
    super.initState();
    selectedCoupon = widget.currentCoupon;
    getData();
  }

  void getData() async {
    AppUser appUser = ref.read(authProvider);
    List<AppCoupon> loadCoupons =
        await ref.read(couponListProvider.notifier).loadCoupons(appUser, true);

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
            : Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: coupons
                                  .map((coupon) => RadioListTile<AppCoupon>(
                                      title: coupon.fireStoreId ==
                                              AppConstants
                                                  .DONT_SELECT_ANY_COUPON
                                          ? const Text(AppConstants
                                              .DONT_SELECT_ANY_COUPON)
                                          : Text(coupon.isAmount
                                              ? "Discount ₹ ${coupon.discountAmount}"
                                              : " Discount ${coupon.discountPercentage}%"),
                                      subtitle: coupon.fireStoreId ==
                                              AppConstants
                                                  .DONT_SELECT_ANY_COUPON
                                          ? null
                                          : Text("Expire On " +
                                              DateFormat("d-MMM-yyyy")
                                                  .format(coupon.endDate) +
                                              " - " +
                                              coupon.fireStoreId),
                                      value: coupon,
                                      groupValue: selectedCoupon,
                                      onChanged: (newCoupon) {
                                        setState(() {
                                          selectedCoupon = newCoupon!;
                                        });
                                      }))
                                  .toList(),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    await ref
                                        .read(orderProvider.notifier)
                                        .updateCoupon(ref.read(authProvider),
                                            selectedCoupon);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Apply")),
                            ))
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
