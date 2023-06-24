import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable(explicitToJson: true)
class Order {
  Map<String, double> selectedMenuItem;
  List<String> selectedCustomMenu;
  double customThaliPrice;
  double totalCount;
  double totalPrice;
  double totalAfterTax;
  final double tax = 5.2;

  Order({
    required this.selectedMenuItem,
    required this.selectedCustomMenu,
    required this.customThaliPrice,
    required this.totalCount,
    required this.totalPrice,
    required this.totalAfterTax,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  Order copyWith(
          {Map<String, double>? selectedMenuItem,
          List<String>? selectedCustomMenu,
          double? customThaliPrice,
          double? totalCount,
          double? totalPrice,
          double? totalAfterTax}) =>
      Order(
        selectedMenuItem: selectedMenuItem ?? this.selectedMenuItem,
        selectedCustomMenu: selectedCustomMenu ?? this.selectedCustomMenu,
        customThaliPrice: customThaliPrice ?? this.customThaliPrice,
        totalCount: totalCount ?? this.totalCount,
        totalPrice: totalPrice ?? this.totalPrice,
        totalAfterTax: totalAfterTax ?? this.totalAfterTax,
      );
}
