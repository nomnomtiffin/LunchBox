// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Combo _$ComboFromJson(Map<String, dynamic> json) => Combo(
      comboName: json['comboName'] as String,
      comboPrice: json['comboPrice'] as int,
      comboItems: (json['comboItems'] as List<dynamic>)
          .map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ComboToJson(Combo instance) => <String, dynamic>{
      'comboName': instance.comboName,
      'comboPrice': instance.comboPrice,
      'comboItems': instance.comboItems.map((e) => e.toJson()).toList(),
    };
