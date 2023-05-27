import 'package:lunch_box/model/combo.dart';
import 'package:lunch_box/model/menu.dart';
import 'package:lunch_box/model/menu_item.dart';

class DummyMenu {
  static MenuItem rice =
      const MenuItem(id: 1, name: "Rice", type: "Veg", price: 10);
  static MenuItem dal =
      const MenuItem(id: 2, name: "Dal", type: "Veg", price: 10);
  static MenuItem aluBhaja =
      const MenuItem(id: 3, name: "Alu Bhaja", type: "Veg", price: 5);
  static MenuItem aluDum =
      const MenuItem(id: 4, name: "Alu Dum", type: "Veg", price: 10);
  static MenuItem soyaBean =
      const MenuItem(id: 5, name: "Soya Bean", type: "Veg", price: 10);
  static MenuItem echor =
      const MenuItem(id: 6, name: "Echor", type: "Veg", price: 20);
  static MenuItem katlaKalia =
      const MenuItem(id: 7, name: "Katla Kalia", type: "Non-Veg", price: 50);
  static MenuItem chickenKosha =
      const MenuItem(id: 8, name: "Chiken Kosha", type: "Non-Veg", price: 70);
  static MenuItem eggCurry =
      const MenuItem(id: 8, name: "Egg Curry", type: "Non-Veg", price: 70);
  static MenuItem paneerButterMasala = const MenuItem(
      id: 9, name: "Paneer Butter Masala", type: "Veg", price: 30);
  static MenuItem tomatoChutney =
      const MenuItem(id: 10, name: "Tomato Chutney", type: "Desert", price: 10);
  static MenuItem Rosogolla =
      const MenuItem(id: 11, name: "Rosogolla", type: "Desert", price: 10);

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

    Menu menu =
        Menu(menuDate: DateTime.now(), menuItems: menuItems, combos: combos);
    return menu;
  }
}
