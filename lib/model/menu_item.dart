import 'package:json_annotation/json_annotation.dart';

part 'menu_item.g.dart';

@JsonSerializable(explicitToJson: true)
class MenuItem {
  final int id;
  final String name;
  final String type;
  final int price;
  final int order;

  const MenuItem(
      {required this.id,
      required this.name,
      required this.type,
      required this.price,
      required this.order});

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemToJson(this);
}
