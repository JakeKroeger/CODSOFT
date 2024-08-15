import 'package:alarm_app/pages/alarm_notification_page.dart';
import 'package:alarm_app/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Alarm.init(showDebugLogs: true);
  } catch (e) {
    print("Alarm initialization failed: $e");
  }

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
