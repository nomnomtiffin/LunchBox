import 'package:json_annotation/json_annotation.dart';

part 'ingredient.g.dart';

@JsonSerializable(explicitToJson: true)
class Ingredient {
  final int id;
  final String name;
  final String type;
  final double quantity;

  Ingredient(
      {required this.id,
      required this.name,
      required this.type,
      required this.quantity});

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);

  Ingredient copyWith({
    int? id,
    String? name,
    String? type,
    double? quantity,
  }) =>
      Ingredient(
          id: id ?? this.id,
          name: name ?? this.name,
          type: type ?? this.type,
          quantity: quantity ?? this.quantity);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ingredient && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
