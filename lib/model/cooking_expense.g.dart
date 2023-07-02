// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cooking_expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CookingExpense _$CookingExpenseFromJson(Map<String, dynamic> json) =>
    CookingExpense(
      ingredientId: json['ingredientId'] as int,
      quantityBought: (json['quantityBought'] as num).toDouble(),
      quantityRemaining: (json['quantityRemaining'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      perUnitPrice: (json['perUnitPrice'] as num).toDouble(),
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      fireStoreId: json['fireStoreId'] as String,
      boughtBy: json['boughtBy'] as String,
    );

Map<String, dynamic> _$CookingExpenseToJson(CookingExpense instance) =>
    <String, dynamic>{
      'ingredientId': instance.ingredientId,
      'quantityBought': instance.quantityBought,
      'quantityRemaining': instance.quantityRemaining,
      'price': instance.price,
      'perUnitPrice': instance.perUnitPrice,
      'purchaseDate': instance.purchaseDate.toIso8601String(),
      'fireStoreId': instance.fireStoreId,
      'boughtBy': instance.boughtBy,
    };
