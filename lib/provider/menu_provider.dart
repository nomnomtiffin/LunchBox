import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/model/menu.dart';
import 'package:lunch_box/util/dummy_menu.dart';

class MenuNotifier extends StateNotifier<Menu> {
  MenuNotifier() : super(DummyMenu.getMenu());
}

final menuProvider = StateNotifierProvider<MenuNotifier, Menu>((ref) {
  return MenuNotifier();
});
