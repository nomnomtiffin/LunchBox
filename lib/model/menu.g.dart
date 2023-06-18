// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map<String, dynamic> json) => Menu(
      menuDate: DateTime.parse(json['menuDate'] as String),
      menuItems: (json['menuItems'] as List<dynamic>)
          .map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      combos: (json['combos'] as List<dynamic>)
          .map((e) => Combo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
      'menuDate': instance.menuDate.toIso8601String(),
      'menuItems': instance.menuItems.map((e) => e.toJson()).toList(),
      'combos': instance.combos.map((e) => e.toJson()).toList(),
    };
