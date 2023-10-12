import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lunch_box/model/menu.dart';

class MenuDetailNotifier extends StateNotifier<Menu> {
  MenuDetailNotifier()
      : super(Menu(menuDate: DateTime.now(), menuItems: [], combos: []));

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> getMenu(DateTime selectedDate) async {
    DocumentSnapshot snapshot = await _firestore
        .collection("menu")
        .doc(DateFormat("d-MMM-yyyy").format(selectedDate))
        .get();
    if (snapshot.exists) {
      state = Menu.fromJson(snapshot.data() as Map<String, dynamic>);
    }
  }
}

final menuProvider = StateNotifierProvider<MenuDetailNotifier, Menu>((ref) {
  return MenuDetailNotifier();
});
