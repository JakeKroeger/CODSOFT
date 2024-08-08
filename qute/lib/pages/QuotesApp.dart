import 'package:flutter/material.dart';
import 'package:qute/pages/QuotesPage.dart';

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
