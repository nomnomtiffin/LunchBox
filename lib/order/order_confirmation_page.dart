import 'package:flutter/material.dart';
import 'package:lunch_box/model/app_order.dart';
import 'package:lunch_box/tabs.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
            Expanded(
              child: Column(
                children: [
                  Text("Thank you for placing the order " + widget.order.name!,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        QrImageView(
                          data: widget.order.fireStoreId,
                          version: QrVersions.auto,
                          size: 200,
                        ),
                        Text(
                          widget.order.fireStoreId,
                          style: TextStyle(
                              fontSize: 10.0,
                              color: Theme.of(context).disabledColor),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          "Please show this qr code while receiving the delivery.",
                          softWrap: true,
                        ),
                        const Text(
                          "You can access it again from your Orders page.",
                          softWrap: true,
                        )
                      ],
                    ),
                  )
                ],
              ),
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
