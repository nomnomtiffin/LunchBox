import 'package:customizable_counter/customizable_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/coupon/select_coupon_page.dart';
import 'package:lunch_box/model/app_user.dart';
import 'package:lunch_box/model/combo.dart';
import 'package:lunch_box/model/menu.dart';
import 'package:lunch_box/model/menu_item.dart';
import 'package:lunch_box/order/order_detail_page.dart';
import 'package:lunch_box/provider/auth_provider.dart';
import 'package:lunch_box/provider/menu_provider.dart';
import 'package:lunch_box/provider/order_provider.dart';
import 'package:lunch_box/tabs.dart';

import '../auth/auth_page.dart';

class OrderPage extends ConsumerStatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  ConsumerState<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrderPage> {
  @override
  void initState() {
    super.initState();
    ref.read(menuProvider.notifier).getMenu();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Your cart",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    ...getContent(),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                            child: ElevatedButton(
                              onPressed: () {
                                ref.watch(orderProvider).totalCount > 0
                                    ? ref
                                            .watch(authProvider.notifier)
                                            .isSignedIn()
                                        ? navToConfirmOrder(context)
                                        : navToAuth(context)
                                    : navToHomePage(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  ref.watch(orderProvider).totalCount > 0
                                      ? ref
                                              .watch(authProvider.notifier)
                                              .isSignedIn()
                                          ? "Confirm Order"
                                          : "Login To Order"
                                      : "Start Ordering",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                backgroundColor: ref
                                        .watch(authProvider.notifier)
                                        .isSignedIn()
                                    ? MaterialStateProperty.all(
                                        Theme.of(context).primaryColor)
                                    : MaterialStateProperty.all(Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Future<dynamic> navToHomePage(BuildContext context) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => const Tabs(
                  selectedPage: 0,
                )),
        (route) => false);
  }

  Future<dynamic> navToAuth(BuildContext context) {
    if (ref.read(orderProvider).fireStoreId.isNotEmpty) {
      ref.read(orderProvider.notifier).saveOrder(
          "LoginToOrder", ref.read(orderProvider).fireStoreId, '', '');
    } else {
      ref.read(orderProvider.notifier).firstTimeSave("LoginToOrder");
    }

    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const AuthPage(2)));
  }

  Future<dynamic> navToConfirmOrder(BuildContext context) {
    AppUser appUser = ref.read(authProvider);
    if (ref.read(orderProvider).fireStoreId.isNotEmpty) {
      ref.read(orderProvider.notifier).saveOrder(
          "ConfirmOrder",
          ref.read(orderProvider).fireStoreId,
          appUser.phoneNumber,
          appUser.uId);
    } else {
      ref.read(orderProvider.notifier).firstTimeSaveWithUid(
          "ConfirmOrder", appUser.phoneNumber, appUser.uId);
    }
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const OrderDetailPage()));
  }

  List<Widget> getContent() {
    List<Widget> contents = [];

    if (ref.watch(orderProvider).totalCount > 0) {
      Menu menu = ref.watch(menuProvider);

      contents.add(Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...getMenuItems(menu),
            ],
          ),
        ),
      ));
      List<Widget> orderDetail = [
        Divider(
          color: Theme.of(context).disabledColor,
        ),
        Row(
          children: [
            Text("Sub Total:",
                style: TextStyle(color: Theme.of(context).disabledColor)),
            const Spacer(),
            Text(
              '₹ ' + ref.watch(orderProvider).totalPrice.toString(),
              style: TextStyle(color: Theme.of(context).disabledColor),
            )
          ],
        ),
        const SizedBox(
          height: 5,
        )
      ];
      //If coupon is available then only add below row
      if (ref.watch(orderProvider).couponApplied != null) {
        orderDetail.add(Row(
          children: [
            Text("Discount:",
                style: TextStyle(color: Theme.of(context).disabledColor)),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => SelectCouponPage(
                          ref.watch(orderProvider).couponApplied!)));
                },
                child: const Text("Change coupon")),
            const Spacer(),
            Text(
              ref.watch(orderProvider).couponApplied!.isAmount
                  ? '₹ ' +
                      ref
                          .watch(orderProvider)
                          .couponApplied!
                          .discountAmount!
                          .toString()
                  : ref
                          .watch(orderProvider)
                          .couponApplied!
                          .discountPercentage!
                          .toString() +
                      "%",
              style: TextStyle(color: Theme.of(context).disabledColor),
            )
          ],
        ));
        orderDetail.add(const SizedBox(
          height: 5,
        ));
      }
      orderDetail.add(Row(
        children: [
          Text("Tax:",
              style: TextStyle(color: Theme.of(context).disabledColor)),
          const Spacer(),
          Text(
            ref.watch(orderProvider).tax.toString() + "%",
            style: TextStyle(color: Theme.of(context).disabledColor),
          )
        ],
      ));
      orderDetail.add(const SizedBox(
        height: 5,
      ));

      contents.add(Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
        child: Column(
          children: [
            ...orderDetail,
            Row(
              children: [
                const Text("Total:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(
                  '₹ ' + ref.watch(orderProvider).totalAfterTax.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                )
              ],
            )
          ],
        ),
      ));
    } else {
      contents.add(Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text("No Items in the cart!!",
                  style: TextStyle(
                      fontSize: 12.0, color: Theme.of(context).disabledColor)),
            ],
          ),
        ),
      ));
    }

    return contents;
  }

  List<Widget> getMenuItems(Menu menu) {
    List<Widget> menuItems = List.empty(growable: true);
    Map<String, double> selectedMenuItem =
        ref.watch(orderProvider).selectedMenuItem;
    //Display Thali
    for (Combo combo in menu.combos) {
      if (selectedMenuItem.keys.contains(combo.comboName) &&
          selectedMenuItem[combo.comboName]! > 0) {
        String comboDescription = '';
        String comboImageName = combo.comboName.replaceAll(" ", "");
        for (MenuItem item in combo.comboItems) {
          if (comboDescription.isNotEmpty) {
            comboDescription += ', ';
          }
          comboDescription += item.name;
        }

        menuItems.add(Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
          child: Card(
            key: ValueKey(comboImageName),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/images/${comboImageName}.jpg",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        combo.comboName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          comboDescription,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context).disabledColor),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '₹ ${combo.comboPrice}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      )
                    ],
                  ),
                  const Spacer(),
                  CustomizableCounter(
                    borderColor: Theme.of(context).colorScheme.primaryContainer,
                    borderWidth: 5,
                    borderRadius: 100,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    buttonText: "Add Item",
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    textSize: 15,
                    count: selectedMenuItem[combo.comboName]!,
                    step: 1,
                    minCount: 0,
                    maxCount: 5,
                    incrementIcon: Icon(Icons.add,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 15),
                    decrementIcon: Icon(Icons.remove,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 15),
                    onIncrement: (count) {
                      ref.read(orderProvider.notifier).setSelectedMenuItem(
                          combo.comboName,
                          count,
                          double.parse(combo.comboPrice.toString()),
                          true,
                          menu.menuDate,
                          ref.read(authProvider));
                    },
                    onDecrement: (count) {
                      ref.read(orderProvider.notifier).setSelectedMenuItem(
                          combo.comboName,
                          count,
                          double.parse(combo.comboPrice.toString()),
                          false,
                          menu.menuDate,
                          ref.read(authProvider));
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
      }
    }

    if (selectedMenuItem.keys.contains("Custom Thali") &&
        selectedMenuItem["Custom Thali"]! > 0) {
      String customThaliDescription = '';
      for (String item in ref.read(orderProvider).selectedCustomMenu) {
        if (customThaliDescription.isNotEmpty) {
          customThaliDescription += ', ';
        }
        customThaliDescription += item;
      }

      //Custom Thali
      menuItems.add(Card(
        key: const ValueKey("CustomThali"),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/images/CustomThali.jpg",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Make your own Thali",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          customThaliDescription,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context).disabledColor),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '₹ ' +
                            ref
                                .watch(orderProvider)
                                .customThaliPrice
                                .toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      )
                    ],
                  ),
                  const Spacer(),
                  AbsorbPointer(
                    absorbing: ref.watch(orderProvider).customThaliPrice < 50,
                    child: CustomizableCounter(
                      borderColor:
                          ref.watch(orderProvider).customThaliPrice < 50
                              ? Theme.of(context).disabledColor
                              : Theme.of(context).colorScheme.primaryContainer,
                      borderWidth: 5,
                      borderRadius: 100,
                      backgroundColor:
                          ref.watch(orderProvider).customThaliPrice < 50
                              ? Theme.of(context).disabledColor
                              : Theme.of(context).colorScheme.primary,
                      buttonText: "Add Item",
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      textSize: 15,
                      count: selectedMenuItem["Custom Thali"]!,
                      step: 1,
                      minCount: 0,
                      maxCount: 5,
                      incrementIcon: Icon(Icons.add,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 15),
                      decrementIcon: Icon(Icons.remove,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 15),
                      onIncrement: (count) {
                        ref.read(orderProvider.notifier).setSelectedMenuItem(
                            "Custom Thali",
                            count,
                            ref.watch(orderProvider).customThaliPrice,
                            true,
                            menu.menuDate,
                            ref.read(authProvider));
                      },
                      onDecrement: (count) {
                        ref.read(orderProvider.notifier).setSelectedMenuItem(
                            "Custom Thali",
                            count,
                            ref.watch(orderProvider).customThaliPrice,
                            false,
                            menu.menuDate,
                            ref.read(authProvider));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
    }

    return menuItems;
  }
}
