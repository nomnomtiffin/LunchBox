import 'package:flutter/material.dart';
import 'package:lunch_box/model/ingredient.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

String roundIngValue(Ingredient ing, double totalRemainingQuantity) {
  String roundedValue = '';
  if ("g" == ing.type) {
    if (totalRemainingQuantity >= 1000) {
      double roundValue = totalRemainingQuantity / 1000;
      double remainderValue = totalRemainingQuantity % 1000;
      roundedValue = roundValue.toStringAsFixed(0) + "kg ";
      if (remainderValue > 0) {
        roundedValue += remainderValue.toString() + "g";
      }
    } else {
      roundedValue = totalRemainingQuantity.toString() + "g";
    }
  } else if ("ml" == ing.type) {
    if (totalRemainingQuantity >= 1000) {
      double roundValue = totalRemainingQuantity / 1000;
      double remainderValue = totalRemainingQuantity % 1000;
      roundedValue = roundValue.toStringAsFixed(0) + "l ";
      if (remainderValue > 0) {
        roundedValue += remainderValue.toString() + "ml";
      }
    } else {
      roundedValue = totalRemainingQuantity.toString() + "ml";
    }
  } else if ("count" == ing.type) {
    roundedValue = totalRemainingQuantity.toString();
  } else {
    roundedValue = totalRemainingQuantity.toString();
  }
  return roundedValue;
}
