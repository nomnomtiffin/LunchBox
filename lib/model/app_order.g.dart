// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppOrder _$AppOrderFromJson(Map<String, dynamic> json) => AppOrder(
      selectedMenuItem: (json['selectedMenuItem'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      selectedCustomMenu: (json['selectedCustomMenu'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      menuDate: json['menuDate'] as String,
      customThaliPrice: (json['customThaliPrice'] as num).toDouble(),
      totalCount: (json['totalCount'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      totalAfterTax: (json['totalAfterTax'] as num).toDouble(),
      uId: json['uId'] as String,
      phoneNumber: json['phoneNumber'] as String,
      name: json['name'] as String,
      address: AppAddress.fromJson(json['address'] as Map<String, dynamic>),
      status: json['status'] as String,
      createDateTime: DateTime.parse(json['createDateTime'] as String),
      lastUpdatedDateTime:
          DateTime.parse(json['lastUpdatedDateTime'] as String),
      fireStoreId: json['fireStoreId'] as String,
      tax: (json['tax'] as num?)?.toDouble() ?? 5.2,
      feedback: json['feedback'] as String?,
      rating: json['rating'] as int?,
    );

Map<String, dynamic> _$AppOrderToJson(AppOrder instance) => <String, dynamic>{
      'selectedMenuItem': instance.selectedMenuItem,
      'selectedCustomMenu': instance.selectedCustomMenu,
      'menuDate': instance.menuDate,
      'customThaliPrice': instance.customThaliPrice,
      'totalCount': instance.totalCount,
      'totalPrice': instance.totalPrice,
      'totalAfterTax': instance.totalAfterTax,
      'tax': instance.tax,
      'uId': instance.uId,
      'phoneNumber': instance.phoneNumber,
      'name': instance.name,
      'address': instance.address.toJson(),
      'status': instance.status,
      'createDateTime': instance.createDateTime.toIso8601String(),
      'lastUpdatedDateTime': instance.lastUpdatedDateTime.toIso8601String(),
      'fireStoreId': instance.fireStoreId,
      'feedback': instance.feedback,
      'rating': instance.rating,
    };
