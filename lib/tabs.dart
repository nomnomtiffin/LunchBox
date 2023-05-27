import 'package:flutter/material.dart';
import 'package:lunch_box/home_page/my_home_page.dart';
import 'package:lunch_box/user/user_page.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() {
    return _TabsState();
  }
}

class _TabsState extends State<Tabs> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const MyHomePage();

    if (_selectedPageIndex == 1) {
      activePage = UserPage();
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
