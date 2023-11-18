import 'package:flutter/material.dart';
import 'package:tif_1/screens/eventScreen.dart';
import 'package:tif_1/screens/eventSearchScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task 1',
      initialRoute: '/eventScreen',
      routes: {
        '/eventScreen' : (context) => const EventScreen(),
        '/eventSearchScreen' : (context) => const EventSearchScreen(),
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const EventScreen();
  }
}

