import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const LukaApp());
}

class LukaApp extends StatelessWidget {
  const LukaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luka',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}