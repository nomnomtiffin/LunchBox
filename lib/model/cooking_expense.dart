import 'package:json_annotation/json_annotation.dart';

part 'cooking_expense.g.dart';

@JsonSerializable(explicitToJson: true)
class CookingExpense {
  final int ingredientId;
  final double quantityBought;
  final double quantityRemaining;
  final double price;
  final double perUnitPrice;
  final DateTime purchaseDate;
  final String fireStoreId;
  final String boughtBy;

  CookingExpense({
    required this.ingredientId,
    required this.quantityBought,
    required this.quantityRemaining,
    required this.price,
    required this.perUnitPrice,
    required this.purchaseDate,
    required this.fireStoreId,
    required this.boughtBy,
  });

  factory CookingExpense.fromJson(Map<String, dynamic> json) =>
      _$CookingExpenseFromJson(json);

  Map<String, dynamic> toJson() => _$CookingExpenseToJson(this);

  CookingExpense copyWith(
          {int? ingredientId,
          double? quantityBought,
          double? quantityRemaining,
          double? price,
          double? perUnitPrice,
          DateTime? purchaseDate,
          String? fireStoreId,
          String? boughtBy}) =>
      CookingExpense(
          ingredientId: ingredientId ?? this.ingredientId,
          quantityBought: quantityBought ?? this.quantityBought,
          quantityRemaining: quantityRemaining ?? this.quantityRemaining,
          price: price ?? this.price,
          perUnitPrice: perUnitPrice ?? this.perUnitPrice,
          purchaseDate: purchaseDate ?? this.purchaseDate,
          fireStoreId: fireStoreId ?? this.fireStoreId,
          boughtBy: boughtBy ?? this.boughtBy);
}
