import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/model/app_order.dart';
import 'package:lunch_box/order/cancel_order_page.dart';
import 'package:lunch_box/provider/search_order_provider.dart';

class SearchOrderPage extends ConsumerStatefulWidget {
  const SearchOrderPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchOrderPage> createState() => _SearchOrderPageState();
}

class _SearchOrderPageState extends ConsumerState<SearchOrderPage> {
  final _formKey = GlobalKey<FormState>();
  String _searchKeyword = '+911234567899';

  //TODO replace the hardcoded date with DateTime.now
  DateTime selectedDate = DateTime(2023, 6, 30);
  bool isLoading = false;
  List<AppOrder> orders = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Order"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    maxLength: 50,
                    initialValue: _searchKeyword,
                    decoration: const InputDecoration(
                      hintText: 'Enter Phone No',
                      border: OutlineInputBorder(),
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
                      _searchKeyword = value!;
                    },
                  ),
                  Row(
                    children: [
                      Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}    '),
                      ElevatedButton(
                        onPressed: changeDate,
                        child: const Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _searchOrder,
                        child: const SizedBox(
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            isLoading
                ? const SafeArea(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : orders.isEmpty
                    ? const Expanded(
                        child: SafeArea(
                            child: Center(
                          child: Text("No orders Available!"),
                        )),
                      )
                    : Expanded(
                        child: ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            //See the example of list view then start
                            return Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(orders[index].name),
                                            Text(orders[index]
                                                .address
                                                .officeName),
                                            SizedBox(
                                              width: 150,
                                              child: Text(
                                                orders[index]
                                                    .address
                                                    .streetAddress,
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Theme.of(context)
                                                        .disabledColor),
                                              ),
                                            ),
                                            Text('Total: ₹' +
                                                orders[index]
                                                    .totalAfterTax
                                                    .toString()),
                                            Text('Status: ' +
                                                orders[index].status),
                                            ...(orders[index]
                                                .selectedMenuItem
                                                .entries
                                                .map((entry) => Text(
                                                    '${entry.key} : ${entry.value}'))
                                                .toList()),
                                          ]),
                                      const Spacer(),
                                      orders[index].status == 'Cancelled'
                                          ? const Text('')
                                          : ElevatedButton(
                                              onPressed: () async {
                                                await Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (ctx) =>
                                                            CancelOrderPage(
                                                                orders[
                                                                    index])));
                                                _searchOrder();
                                              },
                                              child: const Text('Cancel Order'),
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                          itemCount: orders.length,
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  void _searchOrder() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      ref
          .read(searchOrderProvider.notifier)
          .loadOrder(_searchKeyword, selectedDate)
          .then((value) => {
                setState(() {
                  isLoading = false;
                  orders = value;
                })
              });
    }
  }

  changeDate() async {
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2022),
        lastDate: DateTime.now());
    if (newDate == null) return;
    setState(() {
      selectedDate = newDate;
    });
  }
}
