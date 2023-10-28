import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/model/app_address.dart';
import 'package:lunch_box/model/app_order.dart';
import 'package:lunch_box/provider/address_provider.dart';
import 'package:lunch_box/provider/auth_provider.dart';
import 'package:lunch_box/provider/order_provider.dart';

import 'order_confirmation_page.dart';

class OrderDetailPage extends ConsumerStatefulWidget {
  const OrderDetailPage({Key? key}) : super(key: key);

  @override
  ConsumerState<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends ConsumerState<OrderDetailPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  AppAddress? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _selectedAddress =
        ref.read(authProvider).address.officeName.trim().isNotEmpty
            ? ref.read(authProvider).address
            : ref.read(addressProvider).values.first;
    _name = ref.read(authProvider).name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delivery Details")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...getName(),
                            ...getText(
                                "Phone", ref.read(authProvider).phoneNumber),
                            Row(
                              children: [
                                const Text(
                                  "Delivery Address",
                                  style: TextStyle(fontSize: 12.0),
                                ),
                                const Spacer(),
                                TextButton(
                                  child: const Text("Change"),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                    top: Radius.circular(20),
                                                    bottom: Radius.zero),
                                            child: SizedBox(
                                              height: 500,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                    children: getAddresses()),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              _selectedAddress!.officeName +
                                  ", " +
                                  _selectedAddress!.streetAddress,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                const Text("Don't see your office?",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    )),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text("Request new address",
                                      style: TextStyle(
                                        fontSize: 12.0,
                                      )),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
                              child: Text('Proceed to Payment'),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getName() {
    List<Widget> widgets =
        _name.trim().isEmpty ? getNameField() : getText("Name", _name);
    return widgets;
  }

  List<Widget> getNameField() {
    List<Widget> widgets = [];
    widgets.add(TextFormField(
      initialValue: _name,
      maxLength: 50,
      decoration: const InputDecoration(
        label: Text('Name'),
      ),
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            value.trim().length <= 1 ||
            value.trim().length > 50) {
          return 'Must be between 1 and 50 characters.';
        }
        return null;
      },
      onSaved: (value) {
        _name = value!;
      },
    ));
    return widgets;
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (ref.read(authProvider).address != _selectedAddress ||
          ref.read(authProvider).name != _name) {
        ref.read(authProvider.notifier).updateUser(_name, _selectedAddress!);
      }
      await ref.read(orderProvider.notifier).saveDetail(_name,
          ref.read(authProvider).phoneNumber, "Payment", _selectedAddress!);

      //TODO move this to Confirm payment page once implemented
      AppOrder order = ref.read(orderProvider).copyWith();
      ref.read(orderProvider.notifier).paymentConfirmation().then((value) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => OrderConfirmationPage(
                      order,
                    )),
            (route) => false);
      });
    }
  }

  List<Widget> getText(String fieldName, String name) {
    List<Widget> widgets = [];
    widgets.add(Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldName,
            style: const TextStyle(fontSize: 12.0),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    ));
    return widgets;
  }

  List<Widget> getAddresses() {
    List<Widget> widgets = [];
    for (AppAddress address in ref.read(addressProvider).values) {
      widgets.add(Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.officeName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(
                      address.streetAddress,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Theme.of(context).disabledColor),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Radio(
                value: address,
                groupValue: _selectedAddress,
                onChanged: (value) {
                  setState(() {
                    _selectedAddress = address;
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      ));
    }
    return widgets;
  }
}
