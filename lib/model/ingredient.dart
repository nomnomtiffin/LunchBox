import 'package:json_annotation/json_annotation.dart';

part 'ingredient.g.dart';

@JsonSerializable(explicitToJson: true)
class Ingredient {
  final int id;
  final String name;
  final String type;
  final double quantity;

  Ingredient(this.id, this.name, this.type, this.quantity);

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);
}
