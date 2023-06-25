import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/model/app_address.dart';

class AddressNotifier extends StateNotifier<Map<String, AppAddress>> {
  AddressNotifier()
      : super({
          "100001": AppAddress(
              officeName: "Technopolis",
              streetAddress: "Service Rd, BP Block, Sector V, Bidhannagar",
              city: "Kolkata",
              state: "West Bengal",
              zip: 700091),
          "100002": AppAddress(
              officeName: "Unitech Limited",
              streetAddress:
                  "Tower 7, Unit No. 001 & 002 Action Area - III, Main Arterial Road, New Town, Rajarhat",
              city: "Kolkata",
              state: "West Bengal",
              zip: 700156)
        });

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  getAddress() {
    _firestore.collection("app_address").get().then((value) {
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

final addressProvider =
    StateNotifierProvider<AddressNotifier, Map<String, AppAddress>>((ref) {
  return AddressNotifier();
});
