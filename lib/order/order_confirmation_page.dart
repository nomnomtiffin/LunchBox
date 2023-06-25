import 'package:flutter/material.dart';
import 'package:lunch_box/model/app_order.dart';
import 'package:lunch_box/tabs.dart';

class OrderConfirmationPage extends StatefulWidget {
  const OrderConfirmationPage(this.order, {Key? key}) : super(key: key);
  final AppOrder order;

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Column(
              children: [
                Text("Thanks for placing the order " + widget.order.name!),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: ElevatedButton(
                          onPressed: _saveItem,
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text('Back to Home'),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor),
                          )),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _saveItem() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => const Tabs(
                  selectedPage: 0,
                )),
        (route) => false);
  }
}
