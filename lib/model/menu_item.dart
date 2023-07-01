import 'package:json_annotation/json_annotation.dart';
import 'package:lunch_box/model/ingredient.dart';

part 'menu_item.g.dart';

@JsonSerializable(explicitToJson: true)
class MenuItem {
  final int id;
  final String name;
  final String type;
  final int price;
  final int order;
  final List<Ingredient> ingredients;

  const MenuItem(
      {required this.id,
      required this.name,
      required this.type,
      required this.price,
      required this.order,
      required this.ingredients});

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemToJson(this);
}
