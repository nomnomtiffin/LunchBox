import 'package:json_annotation/json_annotation.dart';
import 'package:lunch_box/model/app_address.dart';

part 'app_order.g.dart';

@JsonSerializable(explicitToJson: true)
class AppOrder {
  Map<String, double> selectedMenuItem;
  List<String> selectedCustomMenu;
  String menuDate;
  double customThaliPrice;
  double totalCount;
  double totalPrice;
  double totalAfterTax;
  double tax;
  String uId;
  String phoneNumber;
  String name;
  AppAddress address;
  String
      status; //New, LoginToOrder, ConfirmOrder, Payment, ConfirmPayment, OrderComplete, OrderDelivered, Cancelled
  DateTime createDateTime;
  DateTime lastUpdatedDateTime;
  String fireStoreId;

  AppOrder({
    required this.selectedMenuItem,
    required this.selectedCustomMenu,
    required this.menuDate,
    required this.customThaliPrice,
    required this.totalCount,
    required this.totalPrice,
    required this.totalAfterTax,
    required this.uId,
    required this.phoneNumber,
    required this.name,
    required this.address,
    required this.status,
    required this.createDateTime,
    required this.lastUpdatedDateTime,
    required this.fireStoreId,
    this.tax = 5.2,
  });

  factory AppOrder.fromJson(Map<String, dynamic> json) =>
      _$AppOrderFromJson(json);

  Map<String, dynamic> toJson() => _$AppOrderToJson(this);

  AppOrder copyWith({
    Map<String, double>? selectedMenuItem,
    List<String>? selectedCustomMenu,
    String? menuDate,
    double? customThaliPrice,
    double? totalCount,
    double? totalPrice,
    double? totalAfterTax,
    String? uId,
    String? phoneNumber,
    String? name,
    AppAddress? address,
    String? status,
    DateTime? createDateTime,
    DateTime? lastUpdatedDateTime,
    String? fireStoreId,
  }) =>
      AppOrder(
        selectedMenuItem: selectedMenuItem ?? this.selectedMenuItem,
        selectedCustomMenu: selectedCustomMenu ?? this.selectedCustomMenu,
        menuDate: menuDate ?? this.menuDate,
        customThaliPrice: customThaliPrice ?? this.customThaliPrice,
        totalCount: totalCount ?? this.totalCount,
        totalPrice: totalPrice ?? this.totalPrice,
        totalAfterTax: totalAfterTax ?? this.totalAfterTax,
        uId: uId ?? this.uId,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        name: name ?? this.name,
        address: address ?? this.address,
        status: status ?? this.status,
        createDateTime: createDateTime ?? this.createDateTime,
        lastUpdatedDateTime: lastUpdatedDateTime ?? this.lastUpdatedDateTime,
        fireStoreId: fireStoreId ?? this.fireStoreId,
      );
}
