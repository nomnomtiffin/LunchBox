import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lunch_box/tabs.dart';

import 'home_page/my_home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) {
    runApp(const MyApp());
  });

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'nom nom - Lunch Box',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const Tabs(),
    );
  }
}


