import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/model/app_order.dart';
import 'package:lunch_box/provider/order_detail_provider.dart';
import 'package:lunch_box/util/loading_util.dart';

class CancelOrderPage extends ConsumerStatefulWidget {
  const CancelOrderPage(this.order, {Key? key}) : super(key: key);
  final AppOrder order;
  @override
  ConsumerState<CancelOrderPage> createState() => _CancelOrderPageState();
}

class _CancelOrderPageState extends ConsumerState<CancelOrderPage> {
  final _cardFormKey = GlobalKey<FormState>();
  final List<String> _feedbacks = [
    'Select feedback',
    'Not able to deliver',
    'Food got rotten',
    'Hair in food',
    'Not available for pickup',
    'Other'
  ];
  String _selectedFeedback = 'Select feedback';
  String _otherFeedback = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancel Order'),
      ),
      body: SafeArea(
          child: Form(
        key: _cardFormKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...getOrderDetail(widget.order),
                          DropdownButtonFormField(
                              items: _feedbacks
                                  .map((feedback) => DropdownMenuItem(
                                        child: Text(feedback),
                                        value: feedback,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedFeedback = value as String;
                                });
                              },
                              validator: (value) {
                                if (_selectedFeedback == 'Select feedback') {
                                  return 'Please select a feedback to cancel.';
                                }
                                return null;
                              },
                              value: _feedbacks[0]),
                          TextFormField(
                            maxLength: 200,
                            enabled: _selectedFeedback == 'Other',
                            decoration: const InputDecoration(
                              hintText: 'Enter feedback',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (_selectedFeedback == 'Other' &&
                                  (value == null ||
                                      value.isEmpty ||
                                      value.trim().length <= 1 ||
                                      value.trim().length > 200)) {
                                return 'Feedback must be between 1 and 200 characters.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _otherFeedback = value!;
                            },
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_cardFormKey.currentState!.validate()) {
                                LoadingUtils(context).startLoading();
                                _cardFormKey.currentState!.save();
                                String feedback = _selectedFeedback;
                                if (feedback == 'Other') {
                                  feedback += " : " + _otherFeedback;
                                }
                                await ref
                                    .read(orderDetailProvider.notifier)
                                    .cancelOrder(widget.order, feedback);
                                LoadingUtils(context).stopLoading();
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Cancel Order'),
                          )
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  List<Widget> getOrderDetail(AppOrder order) {
    List<Widget> widgets = [];
    widgets.add(Text(order.fireStoreId));
    widgets.add(Text(order.name));
    widgets.add(Text(order.phoneNumber));
    for (MapEntry<String, double> thali in order.selectedMenuItem.entries) {
      widgets.add(Text(thali.key + " : " + thali.value.toString()));
    }
    return widgets;
  }
}
