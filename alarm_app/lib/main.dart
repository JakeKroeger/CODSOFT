// lib/main.dart
import 'package:alarm_app/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'models/clockpainter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clock App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Homepage(),
      },
    );
  }
}
