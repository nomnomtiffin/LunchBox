import 'package:lunch_box/model/ingredient.dart';

class ShoppingItem {
  final int id;
  final Ingredient ingredient;
  double totalQuantity;
  double price;

  ShoppingItem(this.id, this.ingredient, this.totalQuantity, this.price);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
