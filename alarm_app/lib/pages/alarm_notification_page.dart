import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alarm/alarm.dart' as alarmPlugin;

class AlarmNotificationPage extends StatelessWidget {
  final String label;
  final alarmPlugin.AlarmSettings alarmSettings;
  final TimeOfDay time;

  AlarmNotificationPage({
    required this.label,
    required this.alarmSettings,
    required this.time,
  });

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
              alarmSettings.notificationTitle,
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
              alarmSettings.notificationBody,
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
                    // Stop the snooze alarm
                    alarmPlugin.Alarm.stop(alarmSettings.id);
                    final now = DateTime.now();

                    DateTime alarmTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      time.hour,
                      time.minute,
                    );
                    // Reset the original alarm to ring daily
                    alarmPlugin.Alarm.set(
                      alarmSettings: alarmSettings.copyWith(
                        id: label.hashCode,
                        dateTime: alarmTime.add(Duration(days: 1)),
                      ),
                    );

                    Navigator.of(context).pop();
                  },
                  child: Text('Dismiss'),
                ),
                SizedBox(width: 20),

                // Snooze button
                ElevatedButton(
                  onPressed: () {
                    final snoozeDuration = Duration(seconds: 5);
                    final now = DateTime.now();

                    // Stop the current alarm
                    alarmPlugin.Alarm.stop(alarmSettings.id);

                    // Set the original alarm for the next day

                    // Schedule the snooze alarm for 5 minutes later
                    alarmPlugin.Alarm.set(
                      alarmSettings: alarmSettings.copyWith(
                        id: alarmSettings.id +
                            1, // Use a different ID for snooze
                        dateTime: now.add(snoozeDuration),
                      ),
                    );

                    Navigator.of(context).pop();
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
