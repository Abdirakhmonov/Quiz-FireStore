import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/home_page.dart';
import 'custom_text_field.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DrawerHeader(
              child: SizedBox(),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => const QuestionForm(),
                  ),
                );
              },
              child: const Text(
                "Admin Page",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => const Homepage(),
                  ),
                );
              },
              child: const Text(
                "Home",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
