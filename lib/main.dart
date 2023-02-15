import 'package:flutter/material.dart';
import 'package:mew_mew/pages/accepted_page.dart';

import 'package:mew_mew/pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      theme: ThemeData.dark().copyWith(
          textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white, fontSize: 20)),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            textStyle: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ))),
      routes: {
        "home page": (context) => const HomePage(),
        "accepted page": (context) => const AcceptedList(),
      },
    );
  }
}
