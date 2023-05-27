import 'package:lunch_box/model/menu_item.dart';

import 'combo.dart';

class Menu {
  final DateTime menuDate;
  final List<MenuItem> menuItems;
  final List<Combo> combos;

  const Menu(
      {required this.menuDate, required this.menuItems, required this.combos});
}
