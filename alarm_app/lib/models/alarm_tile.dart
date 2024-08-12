import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlarmTile extends StatefulWidget {
  final TimeOfDay time;
  final String label;

  AlarmTile({
    required this.time,
    required this.label,
  });

  @override
  State<AlarmTile> createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  bool isSwitched = false;
  void toggleSwitch() {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
      });
      print('Switch Button is OFF');
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final hours = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final minutes = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hours:$minutes $period';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xff5215fc),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          onTap: () {},
          title: Text(
            formatTimeOfDay(widget.time),
            style: GoogleFonts.mulish(
              color: Color(0xFFECECEC),
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            widget.label,
            style: GoogleFonts.mulish(
              color: Color(0xFFECECEC),
              fontSize: 16.0,
              fontWeight: FontWeight.w300,
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              toggleSwitch();
            },
            icon: Icon(
              isSwitched ? Icons.toggle_on_rounded : Icons.toggle_off_outlined,
              size: 50,
              color: isSwitched
                  ? Color.fromARGB(234, 172, 144, 238)
                  : Color.fromARGB(115, 0, 0, 0),
            ),
          ),
        ),
      ),
    );
  }
}
