import 'package:lunch_box/model/menu_item.dart';

class Menu {
  final DateTime menuDate;
  final List<MenuItem> menuItems;

  const Menu({required this.menuDate, required this.menuItems});
}
