
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/home_page.dart';
import 'custom_text_field.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DrawerHeader(
            child: SizedBox(),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (context) => QuestionForm(),
                ),
              );
            },
            child: const Text("Admin Page"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (context) => const Homepage(),
                ),
              );
            },
            child: const Text("Home"),
          ),
        ],
      ),
    );
  }
}
