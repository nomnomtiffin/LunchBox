import 'package:json_annotation/json_annotation.dart';

part 'app_coupon.g.dart';

@JsonSerializable(explicitToJson: true)
class AppCoupon {
  String? uId;
  String fireStoreId;
  String? couponName;
  int count;
  int redeemCount;
  DateTime startDate;
  DateTime endDate;
  List<String>? redeemIds;
  bool isAmount;
  double? discountAmount;
  double? discountPercentage;
  bool available;

  AppCoupon(
      {this.uId,
      required this.fireStoreId,
      this.couponName,
      required this.count,
      required this.redeemCount,
      required this.startDate,
      required this.endDate,
      this.redeemIds,
      required this.isAmount,
      this.discountAmount,
      this.discountPercentage,
      required this.available});

  factory AppCoupon.fromJson(Map<String, dynamic> json) =>
      _$AppCouponFromJson(json);

  Map<String, dynamic> toJson() => _$AppCouponToJson(this);

  AppCoupon copyWith({
    String? uId,
    String? fireStoreId,
    String? couponName,
    int? count,
    int? redeemCount,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? redeemIds,
    bool? isAmount,
    double? discountAmount,
    double? discountPercentage,
    bool? available,
  }) =>
      AppCoupon(
        uId: uId ?? this.uId,
        fireStoreId: fireStoreId ?? this.fireStoreId,
        couponName: couponName ?? this.couponName,
        count: count ?? this.count,
        redeemCount: redeemCount ?? this.redeemCount,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        redeemIds: redeemIds ?? this.redeemIds,
        isAmount: isAmount ?? this.isAmount,
        discountAmount: discountAmount ?? this.discountAmount,
        discountPercentage: discountPercentage ?? this.discountPercentage,
        available: available ?? this.available,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppCoupon &&
          runtimeType == other.runtimeType &&
          fireStoreId == other.fireStoreId;

  @override
  int get hashCode => fireStoreId.hashCode;
}
