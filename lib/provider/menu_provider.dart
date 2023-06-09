import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/util/dummy_menu.dart';

final menuProvider = Provider((ref) {
  return DummyMenu.getMenu();
});
