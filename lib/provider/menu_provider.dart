import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lunch_box/model/menu.dart';

class MenuNotifier extends StateNotifier<Menu> {
  MenuNotifier()
      : super(Menu(menuDate: DateTime.now(), menuItems: [], combos: []));

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> getMenu() async {
    //if(currentDate == menuDate && state.menuItems.isNotEmpty && state.combos.isNotEmpty)
    if (state.menuItems.isEmpty && state.combos.isEmpty) {
      DocumentSnapshot snapshot = await _firestore
          .collection("menu")
          .doc(DateFormat("d-MMM-yyyy").format(DateTime(2023, 6,
              15))) //TODO set the date dynamically based on the current date
          .get();
      if (snapshot.exists) {
        state = Menu.fromJson(snapshot.data() as Map<String, dynamic>);
      }
    } else {
      return;
    }
  }
}

final menuProvider = StateNotifierProvider<MenuNotifier, Menu>((ref) {
  return MenuNotifier();
});
