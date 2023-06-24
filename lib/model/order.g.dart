// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      selectedMenuItem: (json['selectedMenuItem'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      selectedCustomMenu: (json['selectedCustomMenu'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      customThaliPrice: (json['customThaliPrice'] as num).toDouble(),
      totalCount: (json['totalCount'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      totalAfterTax: (json['totalAfterTax'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'selectedMenuItem': instance.selectedMenuItem,
      'selectedCustomMenu': instance.selectedCustomMenu,
      'customThaliPrice': instance.customThaliPrice,
      'totalCount': instance.totalCount,
      'totalPrice': instance.totalPrice,
      'totalAfterTax': instance.totalAfterTax,
    };
