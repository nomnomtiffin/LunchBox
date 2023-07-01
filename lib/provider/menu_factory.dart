import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lunch_box/model/category.dart';
import 'package:lunch_box/model/ingredient.dart';
import 'package:lunch_box/model/menu.dart';
import 'package:lunch_box/model/menu_item.dart';

class MenuFactory {
  /*static MenuItem rice =
      const MenuItem(id: 1, name: "Rice", type: "Veg", price: 10, order: 1);
  static MenuItem dal =
      const MenuItem(id: 2, name: "Dal", type: "Veg", price: 10, order: 2);
  static MenuItem aluBhaja =
      const MenuItem(id: 3, name: "Alu Bhaja", type: "Veg", price: 5, order: 3);
  static MenuItem aluDum =
      const MenuItem(id: 4, name: "Alu Dum", type: "Veg", price: 10, order: 4);
  static MenuItem soyaBean = const MenuItem(
      id: 5, name: "Soya Bean", type: "Veg", price: 10, order: 5);
  static MenuItem echor =
      const MenuItem(id: 6, name: "Echor", type: "Veg", price: 20, order: 6);
  static MenuItem katlaKalia = const MenuItem(
      id: 7, name: "Katla Kalia", type: "Non-Veg", price: 50, order: 7);
  static MenuItem chickenKosha = const MenuItem(
      id: 8, name: "Chiken Kosha", type: "Non-Veg", price: 70, order: 8);
  static MenuItem eggCurry = const MenuItem(
      id: 9, name: "Egg Curry", type: "Non-Veg", price: 70, order: 9);
  static MenuItem paneerButterMasala = const MenuItem(
      id: 10, name: "Paneer Butter Masala", type: "Veg", price: 30, order: 10);*/

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Map<DateTime, Menu> menuMap = {};
  static List<MenuItem> menuItems = List.empty(growable: true);
  static Category categories = const Category(categories: []);
  static final List<String> quantityTypes = ['ml', 'l', 'g', 'kg', 'count'];
  static List<Ingredient> ingredients = [];

  static Future<List<String>> getCategories() async {
    if (categories.categories.isEmpty) {
      DocumentSnapshot snapshot =
          await _firestore.collection("category").doc("categories").get();
      if (snapshot.exists) {
        categories = Category.fromJson(snapshot.data() as Map<String, dynamic>);
      }
    }
    return categories.categories;
  }

  static void setCategories(List<String> newCategories) {
    categories = Category(categories: newCategories);
    _firestore
        .collection("category")
        .doc("categories")
        .set(categories.toJson());
  }

  static Future<Menu?> getMenuByDate(DateTime selectedDate) async {
    Menu? menu = menuMap[selectedDate];
    if (menu == null) {
      DocumentSnapshot snapshot = await _firestore
          .collection("menu")
          .doc(DateFormat("d-MMM-yyyy").format(selectedDate))
          .get();
      if (snapshot.exists) {
        menu = Menu.fromJson(snapshot.data() as Map<String, dynamic>);
        menuMap[selectedDate] = menu;
      }
    }
    return menu;
  }

  static Future<void> setMenuByDate(DateTime selectedDate, Menu menu) async {
    menuMap[selectedDate] = menu;
    await _firestore
        .collection("menu")
        .doc(DateFormat("d-MMM-yyyy").format(selectedDate))
        .set(menu.toJson())
        .then((value) => {});
  }

  static void setMenuItem(List<MenuItem> updatedMenuItems) {
    int counter = 1;
    List<MenuItem> newMenuItems = [];
    for (MenuItem item in updatedMenuItems) {
      MenuItem newItem = MenuItem(
          id: item.id,
          name: item.name,
          type: item.type,
          price: item.price,
          order: counter++,
          ingredients: item.ingredients);
      _firestore
          .collection("menu_item")
          .doc(newItem.id.toString())
          .set(newItem.toJson())
          .then((value) => {
                print("saved in menu_item for id: " +
                    newItem.id.toString() +
                    " name : " +
                    newItem.name)
              });
      newMenuItems.add(newItem);
    }
    menuItems = newMenuItems;
  }

  static void setIngredient(Ingredient ingredient) {
    _firestore
        .collection("ingredient")
        .doc(ingredient.id.toString())
        .set(ingredient.toJson())
        .then((value) => ingredients.add(ingredient))
        .onError((error, stackTrace) => print(error.toString()));
  }

  static Future<List<MenuItem>> getAllMenu() async {
    if (menuItems.isEmpty) {
      CollectionReference _collectionRef = _firestore.collection("menu_item");
      QuerySnapshot querySnapshot = await _collectionRef.get();

      // Get data from docs and convert map to List
      final allData = querySnapshot.docs.map((doc) => doc.data()!).toList();
      if (allData.isNotEmpty) {
        for (Object data in allData) {
          var menuItemMap = data as Map<String, dynamic>;
          var menuItem = MenuItem.fromJson(menuItemMap);
          menuItems.add(menuItem);
        }
        menuItems.sort((a, b) => a.order.compareTo(b.order));
      }
    }

    return menuItems;
  }

  static Future<List<Ingredient>> getIngredients() async {
    if (ingredients.isEmpty) {
      CollectionReference _collectionRef = _firestore.collection("ingredient");
      QuerySnapshot querySnapshot = await _collectionRef.get();

      // Get data from docs and convert map to List
      final allData = querySnapshot.docs.map((doc) => doc.data()!).toList();
      if (allData.isNotEmpty) {
        for (Object data in allData) {
          var ingredientMap = data as Map<String, dynamic>;
          var ingredient = Ingredient.fromJson(ingredientMap);
          ingredients.add(ingredient);
        }
      }
    }

    return ingredients;
  }
}
