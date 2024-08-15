import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlarmNotificationPage extends StatefulWidget {
  final String label;
  final AlarmSettings alarmSettings;

  AlarmNotificationPage({
    required this.label,
    required this.alarmSettings,
  });

  @override
  State<AlarmNotificationPage> createState() => _AlarmNotificationPageState();
}

class _AlarmNotificationPageState extends State<AlarmNotificationPage> {
  int snoozetimes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff171717),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Notification title
            Text(
              widget.alarmSettings.notificationTitle,
              style: GoogleFonts.mulish(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Alarm label
            Text(
              widget.alarmSettings.notificationBody,
              style: GoogleFonts.mulish(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Dismiss button
                ElevatedButton(
                  onPressed: () {
                    Alarm.stop(widget.alarmSettings.id);
                    Navigator.of(context).pop();
                  },
                  child: Text('Dismiss'),
                ),
                SizedBox(width: 20),

                // Snooze button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      snoozetimes++;
                    });
                    print('Snooze pressed $snoozetimes times');

                    // Calculate snooze duration (e.g., 5 minutes)
                    final snoozeDuration = Duration(minutes: 5);

                    // Schedule the alarm to ring again after the snooze duration
                    Alarm.stop(widget.alarmSettings.id);
                    Navigator.of(context).pop();
                    Alarm.set(
                      alarmSettings: widget.alarmSettings.copyWith(
                        dateTime:
                            widget.alarmSettings.dateTime.add(snoozeDuration),
                      ),
                    );
                  },
                  child: Text('Snooze'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
