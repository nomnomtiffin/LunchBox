import 'package:json_annotation/json_annotation.dart';
import 'package:lunch_box/model/menu_item.dart';

import 'combo.dart';

part 'menu.g.dart';

@JsonSerializable(explicitToJson: true)
class Menu {
  final DateTime menuDate;
  final List<MenuItem> menuItems;
  final List<Combo> combos;

  const Menu(
      {required this.menuDate, required this.menuItems, required this.combos});

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);
}
