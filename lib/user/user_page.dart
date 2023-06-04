import 'package:flutter/material.dart';
import 'package:lunch_box/menu/display_menu_items_page.dart';
import 'package:lunch_box/menu/display_menu_page.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Debanjan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                _createMenu(context);
              },
              child: const Text('Create Menu'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => DisplayMenuItemsPage()));
              },
              child: const Text('Menu Item'),
            ),
            TextButton(
              onPressed: () {
                _createMenu(context);
              },
              child: const Text('Categories'),
            ),
          ],
        ),
      ),
    );
  }

  void _createMenu(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => DisplayMenuPage()));
  }
}
