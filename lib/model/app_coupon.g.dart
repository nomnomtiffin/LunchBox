// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppCoupon _$AppCouponFromJson(Map<String, dynamic> json) => AppCoupon(
      uId: json['uId'] as String?,
      fireStoreId: json['fireStoreId'] as String,
      couponName: json['couponName'] as String?,
      count: json['count'] as int,
      redeemCount: json['redeemCount'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      redeemIds: (json['redeemIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isAmount: json['isAmount'] as bool,
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AppCouponToJson(AppCoupon instance) => <String, dynamic>{
      'uId': instance.uId,
      'fireStoreId': instance.fireStoreId,
      'couponName': instance.couponName,
      'count': instance.count,
      'redeemCount': instance.redeemCount,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'redeemIds': instance.redeemIds,
      'isAmount': instance.isAmount,
      'discountAmount': instance.discountAmount,
      'discountPercentage': instance.discountPercentage,
    };
