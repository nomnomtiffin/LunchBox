import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/menu/display_categories_page.dart';
import 'package:lunch_box/menu/display_ingredients_page.dart';
import 'package:lunch_box/menu/display_menu_items_page.dart';
import 'package:lunch_box/menu/display_menu_page.dart';
import 'package:lunch_box/provider/auth_provider.dart';
import 'package:lunch_box/tabs.dart';

class AdminUserPage extends ConsumerWidget {
  const AdminUserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Welcome' + ref.read(authProvider).name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                ref.read(authProvider).phoneNumber,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 12),
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
                      builder: (ctx) => const DisplayMenuItemsPage()));
                },
                child: const Text('Menu Item'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const DisplayCategoriesPage()));
                },
                child: const Text('Categories'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const DisplayIngredientsPage()));
                },
                child: const Text('Ingredients'),
              ),
              TextButton(
                onPressed: () async {
                  await ref
                      .read(authProvider.notifier)
                      .signOutUser(context: context);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const Tabs(
                                selectedPage: 1,
                              )),
                      (route) => false);
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createMenu(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const DisplayMenuPage()));
  }
}
