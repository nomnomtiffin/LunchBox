import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunch_box/home_page/my_home_page.dart';
import 'package:lunch_box/provider/auth_provider.dart';
import 'package:lunch_box/user/admin_user_page.dart';
import 'package:lunch_box/user/user_page.dart';
import 'package:lunch_box/user/user_welcome_page.dart';

class Tabs extends ConsumerStatefulWidget {
  const Tabs({required this.selectedPage, super.key});
  final int selectedPage;
  @override
  ConsumerState<Tabs> createState() {
    return _TabsState();
  }
}

class _TabsState extends ConsumerState<Tabs> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedPageIndex = widget.selectedPage;
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const MyHomePage();

    if (_selectedPageIndex == 1) {
      //activePage = UserPage();
      activePage = ref.watch(authProvider.notifier).isSignedIn()
          ? ref.read(authProvider).phoneNumber == '+911234567899'
              ? const AdminUserPage()
              : const UserPage()
          : const UserWelcomePage();
    }

    return Scaffold(
      /*appBar: AppBar(
        title: const Text(
          'nom nom - lunch box',
          style: TextStyle(fontFamily: 'Sigmar'),
        ),
      ),*/
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
