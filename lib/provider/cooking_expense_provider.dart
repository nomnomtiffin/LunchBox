import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/model/cooking_expense.dart';

class CookingExpenseNotifier extends StateNotifier<List<CookingExpense>> {
  CookingExpenseNotifier() : super([]);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CookingExpense>> getCookingExpense(List<int> ingIds) async {
    QuerySnapshot snapshot = await _firestore
        .collection("cooking_expense")
        .where("ingredientId", whereIn: ingIds)
        .where("quantityRemaining", isGreaterThan: 0)
        .get();
    final allData = snapshot.docs.map((doc) => doc.data()!).toList();
    if (allData.isNotEmpty) {
      List<CookingExpense> expenses = [];
      for (var exp in allData) {
        expenses.add(CookingExpense.fromJson(exp as Map<String, dynamic>));
      }
      state = expenses;
    }
    return List.of(state);
  }

  setCookingExpense(CookingExpense expense) async {
    var documentReference =
        await _firestore.collection("cooking_expense").add(expense.toJson());
    await _firestore
        .collection("cooking_expense")
        .doc(documentReference.id)
        .set(expense.copyWith(fireStoreId: documentReference.id).toJson());
  }
}

final cookingExpenseProvider =
    StateNotifierProvider<CookingExpenseNotifier, List<CookingExpense>>((ref) {
  return CookingExpenseNotifier();
});
