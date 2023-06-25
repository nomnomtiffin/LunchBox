// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppAddress _$AppAddressFromJson(Map<String, dynamic> json) => AppAddress(
      officeName: json['officeName'] as String,
      streetAddress: json['streetAddress'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zip: json['zip'] as int,
    );

Map<String, dynamic> _$AppAddressToJson(AppAddress instance) =>
    <String, dynamic>{
      'officeName': instance.officeName,
      'streetAddress': instance.streetAddress,
      'city': instance.city,
      'state': instance.state,
      'zip': instance.zip,
    };
