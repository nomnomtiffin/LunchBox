import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/coupon/coupon_list_page.dart';
import 'package:lunch_box/menu/display_menu_page.dart';
import 'package:lunch_box/model/app_user.dart';
import 'package:lunch_box/provider/auth_provider.dart';
import 'package:lunch_box/provider/order_provider.dart';
import 'package:lunch_box/tabs.dart';

class UserPage extends ConsumerWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Welcome' + ref.read(authProvider).name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                ref.read(authProvider).phoneNumber,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 12),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Orders'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const CouponListPage()));
                },
                child: const Text('Coupons'),
              ),
              TextButton(
                onPressed: () async {
                  AppUser appUser = await ref
                      .read(authProvider.notifier)
                      .signOutUser(context: context);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const Tabs(
                                selectedPage: 1,
                              )),
                      (route) => false);
                  await ref
                      .read(orderProvider.notifier)
                      .updateCoupon(appUser, null);
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createMenu(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const DisplayMenuPage()));
  }
}
