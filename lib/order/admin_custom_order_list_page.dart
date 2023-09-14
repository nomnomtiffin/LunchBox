import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/model/app_order.dart';
import 'package:lunch_box/provider/order_list_provider.dart';

class AdminCustomOrderListPage extends ConsumerStatefulWidget {
  const AdminCustomOrderListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminCustomOrderListPage> createState() =>
      _AdminCustomOrderListPageState();
}

class _AdminCustomOrderListPageState
    extends ConsumerState<AdminCustomOrderListPage> {
  bool isLoading = false;
  List<AppOrder> orders = [];
  DateTime selectedDate = DateTime(2023);

  @override
  void initState() {
    super.initState();
    //TODO replace the hardcoded date with DateTime.now
    DateTime currentDate = DateTime(2023, 6, 30);
    setState(() {
      selectedDate = currentDate;
      isLoading = true;
    });
    getData(currentDate);
  }

  void getData(DateTime currentDate) {
    List<AppOrder> customOrders = [];
    ref.read(orderListProvider.notifier).loadOrders(currentDate).then((value) {
      value.forEach((order) {
        if (order.selectedCustomMenu.isNotEmpty) {
          customOrders.add(order);
        }
      });
      setState(() {
        isLoading = false;
        orders = customOrders;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Spacer(),
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
                    ? const SafeArea(
                        child: Center(
                        child: Text("No orders Available!"),
                      ))
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
                                            Text(orders[index].phoneNumber),
                                            Text('Count : ' +
                                                orders[index]
                                                    .selectedMenuItem[
                                                        'Custom Thali']
                                                    .toString()),
                                            getOrderList(orders[index]),
                                          ]),
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

  Widget getOrderList(AppOrder order) {
    String customThaliMenu = '';
    for (String item in order.selectedCustomMenu) {
      if (customThaliMenu.isNotEmpty) {
        customThaliMenu += ', ';
      }
      customThaliMenu += item;
    }
    return Text(
      customThaliMenu,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  void changeDate() async {
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2022),
        lastDate: DateTime.now());
    if (newDate == null) return;
    setState(() {
      selectedDate = newDate;
      isLoading = true;
    });
    getData(newDate);
  }
}
