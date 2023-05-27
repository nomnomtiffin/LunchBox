import 'menu_item.dart';

class Combo {
  final String comboName;
  final int comboPrice;
  final List<MenuItem> comboItems;

  const Combo(
      {required this.comboName,
      required this.comboPrice,
      required this.comboItems});
}
