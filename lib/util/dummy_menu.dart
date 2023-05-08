import 'package:lunch_box/model/menu.dart';
import 'package:lunch_box/model/menu_item.dart';

class DummyMenu {
  static Menu getMenu() {
    MenuItem rice = const MenuItem(id: 1, name: "Rice", type: "Veg", price: 10);
    MenuItem dal = const MenuItem(id: 2, name: "Dal", type: "Veg", price: 10);
    MenuItem aluBhaja =
        const MenuItem(id: 3, name: "Alu Bhaja", type: "Veg", price: 5);
    MenuItem aluDum =
        const MenuItem(id: 4, name: "Alu Dum", type: "Veg", price: 10);
    MenuItem soyaBean =
        const MenuItem(id: 5, name: "Soya Bean", type: "Veg", price: 10);
    MenuItem echor =
        const MenuItem(id: 6, name: "Echor", type: "Veg", price: 20);
    MenuItem katlaKalia =
        const MenuItem(id: 7, name: "Katla Kalia", type: "Non-Veg", price: 50);
    MenuItem chickenKosha =
        const MenuItem(id: 8, name: "Chiken Kosha", type: "Non-Veg", price: 70);
    MenuItem paneerButterMasala = const MenuItem(
        id: 9, name: "Paneer Butter Masala", type: "Veg", price: 30);
    MenuItem tomatoChutney = const MenuItem(
        id: 10, name: "Tomato Chutney", type: "Desert", price: 10);
    MenuItem Rosogolla =
        const MenuItem(id: 11, name: "Rosogolla", type: "Desert", price: 10);

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

    Menu menu = Menu(menuDate: DateTime.now(), menuItems: menuItems);
    return menu;
  }
}
