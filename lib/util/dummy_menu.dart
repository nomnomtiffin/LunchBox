import 'package:lunch_box/model/combo.dart';
import 'package:lunch_box/model/menu.dart';
import 'package:lunch_box/model/menu_item.dart';

import '../model/category.dart';

class DummyMenu {
  static MenuItem rice = const MenuItem(
      id: 1, name: "Rice", type: "Veg", price: 10, order: 1, ingredients: []);
  static MenuItem dal = const MenuItem(
      id: 2, name: "Dal", type: "Veg", price: 10, order: 2, ingredients: []);
  static MenuItem aluBhaja = const MenuItem(
      id: 3,
      name: "Alu Bhaja",
      type: "Veg",
      price: 5,
      order: 3,
      ingredients: []);
  static MenuItem aluDum = const MenuItem(
      id: 4,
      name: "Alu Dum",
      type: "Veg",
      price: 10,
      order: 4,
      ingredients: []);
  static MenuItem soyaBean = const MenuItem(
      id: 5,
      name: "Soya Bean",
      type: "Veg",
      price: 10,
      order: 5,
      ingredients: []);
  static MenuItem echor = const MenuItem(
      id: 6, name: "Echor", type: "Veg", price: 20, order: 6, ingredients: []);
  static MenuItem katlaKalia = const MenuItem(
      id: 7,
      name: "Katla Kalia",
      type: "Non-Veg",
      price: 50,
      order: 7,
      ingredients: []);
  static MenuItem chickenKosha = const MenuItem(
      id: 8,
      name: "Chiken Kosha",
      type: "Non-Veg",
      price: 70,
      order: 8,
      ingredients: []);
  static MenuItem eggCurry = const MenuItem(
      id: 9,
      name: "Egg Curry",
      type: "Non-Veg",
      price: 70,
      order: 9,
      ingredients: []);
  static MenuItem paneerButterMasala = const MenuItem(
      id: 10,
      name: "Paneer Butter Masala",
      type: "Veg",
      price: 30,
      order: 10,
      ingredients: []);
  static MenuItem tomatoChutney = const MenuItem(
      id: 11,
      name: "Tomato Chutney",
      type: "Desert",
      price: 10,
      order: 11,
      ingredients: []);
  static MenuItem Rosogolla = const MenuItem(
      id: 12,
      name: "Rosogolla",
      type: "Desert",
      price: 10,
      order: 12,
      ingredients: []);

  static Map<DateTime, Menu> menuMap = {};
  static List<MenuItem> menuItems = List.empty(growable: true);
  static Category category =
      const Category(categories: ['Veg', 'Non-Veg', 'Desert']);

  static List<String> getCategories() {
    return category.categories;
  }

  static void setCategories(List<String> newCategories) {
    category = Category(categories: newCategories);
  }

  static Menu? getMenuByDate(DateTime selectedDate) {
    return menuMap[selectedDate];
  }

  static void setMenuByDate(DateTime selectedDate, Menu menu) {
    menuMap[selectedDate] = menu;
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
      newMenuItems.add(newItem);
    }
    menuItems = updatedMenuItems;
  }

  static List<MenuItem> getAllMenu() {
    if (menuItems.isEmpty) {
      menuItems.add(rice);
      menuItems.add(dal);
      menuItems.add(aluBhaja);
      menuItems.add(aluDum);
      menuItems.add(soyaBean);
      menuItems.add(echor);
      menuItems.add(katlaKalia);
      menuItems.add(chickenKosha);
      menuItems.add(eggCurry);
      menuItems.add(paneerButterMasala);
      menuItems.add(tomatoChutney);
      menuItems.add(Rosogolla);
    }

    return menuItems;
  }

  static Menu getMenu() {
    List<MenuItem> menuItems = List.empty(growable: true);
    menuItems.add(rice);
    menuItems.add(dal);
    menuItems.add(aluBhaja);
    menuItems.add(aluDum);
    menuItems.add(soyaBean);
    menuItems.add(echor);
    menuItems.add(katlaKalia);
    menuItems.add(chickenKosha);
    menuItems.add(paneerButterMasala);
    menuItems.add(tomatoChutney);
    menuItems.add(Rosogolla);

    List<MenuItem> vegThaliItems = List.empty(growable: true);
    vegThaliItems.add(rice);
    vegThaliItems.add(dal);
    vegThaliItems.add(aluBhaja);
    vegThaliItems.add(aluDum);
    vegThaliItems.add(soyaBean);
    Combo vegThali = Combo(
        comboName: 'Veg Thali', comboPrice: 50, comboItems: vegThaliItems);

    List<MenuItem> eggThaliItems = List.empty(growable: true);
    eggThaliItems.add(rice);
    eggThaliItems.add(dal);
    eggThaliItems.add(aluBhaja);
    eggThaliItems.add(aluDum);
    eggThaliItems.add(soyaBean);
    eggThaliItems.add(eggCurry);
    Combo eggThali = Combo(
        comboName: 'Egg Thali', comboPrice: 70, comboItems: eggThaliItems);

    List<MenuItem> fishThaliItems = List.empty(growable: true);
    fishThaliItems.add(rice);
    fishThaliItems.add(dal);
    fishThaliItems.add(aluBhaja);
    fishThaliItems.add(aluDum);
    fishThaliItems.add(soyaBean);
    fishThaliItems.add(katlaKalia);
    Combo fishThali = Combo(
        comboName: 'Fish Thali', comboPrice: 80, comboItems: fishThaliItems);

    List<MenuItem> chickenThaliItems = List.empty(growable: true);
    chickenThaliItems.add(rice);
    chickenThaliItems.add(dal);
    chickenThaliItems.add(aluBhaja);
    chickenThaliItems.add(aluDum);
    chickenThaliItems.add(soyaBean);
    chickenThaliItems.add(chickenKosha);
    Combo chickenThali = Combo(
        comboName: 'Chicken Thali',
        comboPrice: 50,
        comboItems: chickenThaliItems);

    List<Combo> combos = List.empty(growable: true);
    combos.add(vegThali);
    combos.add(eggThali);
    combos.add(fishThali);
    combos.add(chickenThali);

    DateTime now = DateTime.now();
    DateTime currentDate = DateTime(now.year, now.month, now.day);
    Menu menu =
        Menu(menuDate: currentDate, menuItems: menuItems, combos: combos);
    menuMap[currentDate] = menu;
    return menu;
  }
}
