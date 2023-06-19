import 'package:customizable_counter/customizable_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/model/combo.dart';
import 'package:lunch_box/model/menu.dart';
import 'package:lunch_box/model/menu_item.dart';
import 'package:lunch_box/provider/menu_provider.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  Map<String, double> _selectedMenuItem = {};
  List<String> _selectedCustomMenu = [];
  double customThaliPrice = 0;
  @override
  Widget build(BuildContext context) {
    Menu menu = ref.watch(menuProvider);
    DateTime menuDate = menu.menuDate;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Today\'s Menu - ${menuDate.day}-${menuDate.month}-${menuDate.year}',
            ),
            ...getMenuItems(menu)
          ],
        ),
      ),
    );
  }

  List<Widget> getMenuItems(Menu menu) {
    List<Widget> menuItems = List.empty(growable: true);

    //Display Combo
    for (Combo combo in menu.combos) {
      String comboDescription = '';
      String comboImageName = combo.comboName.replaceAll(" ", "");
      for (MenuItem item in combo.comboItems) {
        if (comboDescription.isNotEmpty) {
          comboDescription += ', ';
        }
        comboDescription += item.name;
      }

      menuItems.add(Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/images/${comboImageName}.jpg",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      combo.comboName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        comboDescription,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context).disabledColor),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '₹ ${combo.comboPrice}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    )
                  ],
                ),
                const Spacer(),
                CustomizableCounter(
                  borderColor: Theme.of(context).unselectedWidgetColor,
                  borderWidth: 5,
                  borderRadius: 100,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  buttonText: "Add Item",
                  textColor: Colors.white,
                  textSize: 15,
                  count: 0,
                  step: 1,
                  minCount: 0,
                  maxCount: 5,
                  incrementIcon:
                      const Icon(Icons.add, color: Colors.white, size: 15),
                  decrementIcon:
                      const Icon(Icons.remove, color: Colors.white, size: 15),
                  onCountChange: (count) {
                    _selectedMenuItem[combo.comboName] = count;
                    print(_selectedMenuItem);
                  },
                ),
                /*Transform.scale(
                  scale: 2,
                  child: Checkbox(
                    shape: const CircleBorder(),
                    side: MaterialStateBorderSide.resolveWith(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return BorderSide(
                              width: 2, color: Theme.of(context).primaryColor);
                        }
                        return BorderSide(
                            width: 1,
                            color: Theme.of(context).unselectedWidgetColor);
                      },
                    ),
                    activeColor: Theme.of(context).colorScheme.primary,
                    value: _selectedMenuItem.contains(combo.comboName),
                    onChanged: (value) {
                      setState(() {
                        if (value == null || value == false) {
                          _selectedMenuItem.remove(combo.comboName);
                        } else {
                          _selectedMenuItem.add(combo.comboName);
                        }
                      });
                    },
                  ),
                )*/
              ],
            ),
          ),
        ),
      ));
    }

    //Custom Thali
    menuItems.add(Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/images/CustomThali.jpg",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Make your own Thali",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        "Minimum thali amount should be ₹50",
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context).disabledColor),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '₹ $customThaliPrice',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    )
                  ],
                ),
                const Spacer(),
                AbsorbPointer(
                  absorbing: customThaliPrice < 50,
                  child: CustomizableCounter(
                    borderColor: customThaliPrice < 50
                        ? Colors.grey
                        : Theme.of(context).unselectedWidgetColor,
                    borderWidth: 5,
                    borderRadius: 100,
                    backgroundColor: customThaliPrice < 50
                        ? Colors.grey
                        : Theme.of(context).colorScheme.primary,
                    buttonText: "Add Item",
                    textColor: Colors.white,
                    textSize: 15,
                    count: 0,
                    step: 1,
                    minCount: 0,
                    maxCount: 5,
                    incrementIcon:
                        const Icon(Icons.add, color: Colors.white, size: 15),
                    decrementIcon:
                        const Icon(Icons.remove, color: Colors.white, size: 15),
                    onCountChange: (count) {
                      _selectedMenuItem["Custom Thali"] = count;
                      print(_selectedMenuItem);
                    },
                  ),
                ),
              ],
            ),
            ...getCustomThaliItems(menu),
          ],
        ),
      ),
    ));

    return menuItems;
  }

  List<Widget> getCustomThaliItems(Menu menu) {
    List<Widget> customThaliItems = [];

    //Display custom thali
    Map<String, List<MenuItem>> categories = {};
    for (MenuItem item in menu.menuItems) {
      List<MenuItem> menuItems;
      if (categories.keys.contains(item.type)) {
        menuItems = categories[item.type]!;
      } else {
        menuItems = List.empty(growable: true);
      }
      menuItems.add(item);
      categories[item.type] = menuItems;
    }

    for (String key in categories.keys) {
      customThaliItems.add(Row(
        children: [
          Text(
            key,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ));

      List<MenuItem> items = categories[key]!;
      for (MenuItem menuItem in items) {
        customThaliItems.add(Card(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  menuItem.name,
                ),
              ),
              const Spacer(),
              Text(
                '₹ ${menuItem.price}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary),
              ),
              Transform.scale(
                scale: 1,
                child: Checkbox(
                  shape: const CircleBorder(),
                  side: MaterialStateBorderSide.resolveWith(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return BorderSide(
                            width: 2, color: Theme.of(context).primaryColor);
                      }
                      return BorderSide(
                          width: 1,
                          color: Theme.of(context).unselectedWidgetColor);
                    },
                  ),
                  activeColor: Theme.of(context).colorScheme.primary,
                  value: _selectedCustomMenu.contains(menuItem.name),
                  onChanged: (value) {
                    setState(() {
                      if (value == null || value == false) {
                        _selectedCustomMenu.remove(menuItem.name);
                        customThaliPrice -= menuItem.price;
                      } else {
                        _selectedCustomMenu.add(menuItem.name);
                        customThaliPrice += menuItem.price;
                      }
                    });
                  },
                ),
              )
            ],
          ),
        ));
      }
    }

    return customThaliItems;
  }
}
