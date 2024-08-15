import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:alarm_app/pages/alarm_notification_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/data/latest.dart' as tz;

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
  bool isSwitched = false;
  static StreamSubscription<AlarmSettings>? subscription;

  @override
  void initState() {
    super.initState();
    _initializeTimezone();
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => yourOnRingCallback(alarmSettings),
    );
    _checkAlarms();
  }

  void _checkAlarms() async {
    if (isSwitched) {
      await _setAlarm();
      print("Alarm set checked for ${widget.label} at ${widget.time}");
    } else {
      await _cancelAlarm();
      print("Alarm cancelled checked for ${widget.label} at ${widget.time}");
    }
  }

  void _initializeTimezone() {
    tz.initializeTimeZones();
    print("Timezone initialized.");
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  void yourOnRingCallback(AlarmSettings alarmsettings) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AlarmNotificationPage(
          label: widget.label,
          alarmSettings: alarmsettings,
        ),
      ),
    );
  }

  Future<void> _setAlarm() async {
    final now = DateTime.now();
    DateTime alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      widget.time.hour,
      widget.time.minute,
    );

    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(Duration(days: 1));
    }

    final alarmId = widget.label.hashCode;

    final alarmSettings = AlarmSettings(
      id: alarmId,
      dateTime: alarmTime,
      assetAudioPath: 'assets/Clock2.mp3',
      loopAudio: true,
      vibrate: true,
      volume: 0.8,
      fadeDuration: 3.0,
      notificationTitle: widget.time.format(context),
      notificationBody: widget.label,
      enableNotificationOnKill: Platform.isAndroid,
    );

    await Alarm.set(
      alarmSettings: alarmSettings,
    );
  }

  Future<void> _cancelAlarm() async {
    final alarmId = widget.label.hashCode;
    try {
      await Alarm.stop(alarmId);
      print("Alarm cancelled for ${widget.label} at ${widget.time}");
    } catch (e) {
      print("Error cancelling alarm: $e");
    }
  }

  void toggleSwitch() {
    setState(() {
      isSwitched = !isSwitched;
    });

    if (isSwitched) {
      _setAlarm();
    } else {
      _cancelAlarm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xff171717),
      ),
      child: ListTile(
        title: Text(
          widget.label,
          style: GoogleFonts.mulish(
              textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
        ),
        subtitle: Text(
          '${widget.time.format(context)}',
          style: GoogleFonts.mulish(
              textStyle: const TextStyle(color: Colors.white, fontSize: 15)),
        ),
        trailing: Switch(
          value: isSwitched,
          onChanged: (value) => toggleSwitch(),
          activeTrackColor: Colors.green,
          activeColor: Colors.white,
          inactiveThumbColor:
              Colors.grey, // Set the inactive thumb color to white
          // Set the active thumb color to white
        ),
      ),
    );
  }
}
