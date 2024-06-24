import 'package:flutter/material.dart';
import 'package:week6/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.purple).copyWith(
          scaffoldBackgroundColor: Color.fromARGB(255, 236, 125, 255)),
      home: const Home(),
    );
  }
}
