import 'package:flutter/material.dart';
import 'package:lunch_box/auth/auth_page.dart';

class UserWelcomePage extends StatelessWidget {
  const UserWelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text('nom nom'),
                ),
                Card(
                  margin: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                              'Never a better time than now to book your next lunch.'),
                          const SizedBox(
                            height: 12,
                          ),
                          ElevatedButton(
                              child: const Text('Get Started'),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => const AuthPage(1)));
                              },
                              style: ElevatedButton.styleFrom())
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
