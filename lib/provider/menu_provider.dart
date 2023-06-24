import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lunch_box/model/menu.dart';

class MenuNotifier extends StateNotifier<Menu> {
  MenuNotifier()
      : super(Menu(menuDate: DateTime.now(), menuItems: [], combos: []));

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void getMenu() {
    //if(currentDate == menuDate && state.menuItems.isNotEmpty && state.combos.isNotEmpty)
    if (state.menuItems.isEmpty && state.combos.isEmpty) {
      _firestore
          .collection("menu")
          .doc(DateFormat("d-MMM-yyyy").format(DateTime(2023, 6,
              15))) //TODO set the date dynamically based on the current date
          .get()
          .then((value) {
        if (value.exists) {
          state = Menu.fromJson(value.data() as Map<String, dynamic>);
        }
      });
    }
  }
}

final menuProvider = StateNotifierProvider<MenuNotifier, Menu>((ref) {
  return MenuNotifier();
});
