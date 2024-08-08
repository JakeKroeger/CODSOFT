import 'package:flutter/material.dart';
import 'package:quotes_app/pages/QuotesPage.dart';

class QuotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuotesPage(),
    );
  }
}
