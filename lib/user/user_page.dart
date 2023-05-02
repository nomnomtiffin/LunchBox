
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget{
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'User Info',
        ),
      ],
    );
  }

}