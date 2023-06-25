import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/model/app_address.dart';

class RequestAddressNotifier extends StateNotifier<Map<String, AppAddress>> {
  RequestAddressNotifier() : super({});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  getRequestedAddress() {
    _firestore.collection("request_address").get().then((value) {
      if (value.size > 0) {
        Map<String, AppAddress> addresses = {};
        for (QueryDocumentSnapshot<Map<String, dynamic>> data in value.docs) {
          addresses[data.id] = AppAddress.fromJson(data.data());
        }
        state = addresses;
      }
    });
  }

  requestAddress(AppAddress address) {
    _firestore.collection("request_address").add(address.toJson());
  }
}

final requestAddressProvider =
    StateNotifierProvider<RequestAddressNotifier, Map<String, AppAddress>>(
        (ref) {
  return RequestAddressNotifier();
});
