import 'package:json_annotation/json_annotation.dart';

import 'menu_item.dart';

part 'combo.g.dart';

@JsonSerializable(explicitToJson: true)
class Combo {
  final String comboName;
  final int comboPrice;
  final List<MenuItem> comboItems;

  const Combo(
      {required this.comboName,
      required this.comboPrice,
      required this.comboItems});

  factory Combo.fromJson(Map<String, dynamic> json) => _$ComboFromJson(json);

  Map<String, dynamic> toJson() => _$ComboToJson(this);
}
