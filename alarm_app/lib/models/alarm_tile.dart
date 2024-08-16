import 'dart:async';
import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:alarm_app/pages/alarm_notification_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/data/latest.dart' as tz;

class AlarmTile extends StatefulWidget {
  final TimeOfDay time;
  final String label;
  final bool isSwitched;
  final Function(bool) onSwitchChanged;
  final String tune;

  AlarmTile({
    required this.time,
    required this.label,
    required this.isSwitched,
    required this.onSwitchChanged,
    required this.tune,
  });

  @override
  State<AlarmTile> createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {
  late bool isSwitched;
  static StreamSubscription<AlarmSettings>? subscription;

  @override
  void initState() {
    super.initState();
    isSwitched = widget.isSwitched;
    _initializeTimezone();
    // Move subscription initialization to didChangeDependencies
    // subscription ??= Alarm.ringStream.stream.listen(
    //   (alarmSettings) => yourOnRingCallback(alarmSettings),
    // );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the subscription here, after context is available
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => yourOnRingCallback(alarmSettings),
    );
    _checkAlarms();
  }

  void _checkAlarms() async {
    if (isSwitched) {
      await _setAlarm();
    } else {
      await _cancelAlarm();
    }
  }

  void _initializeTimezone() {
    tz.initializeTimeZones();
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
          time: widget.time,
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
    print("THE SOUND OF THE ALARM IS: ${widget.tune}");

    final alarmSettings = AlarmSettings(
      id: alarmId,
      dateTime: alarmTime,
      assetAudioPath: 'assets/chimes.mp3',
      loopAudio: true,
      vibrate: true,
      volume: 0.8,
      fadeDuration: 3.0,
      notificationTitle: widget.time.format(context),
      notificationBody: widget.label,
      enableNotificationOnKill: Platform.isAndroid,
    );
    print("alarm set with audio path: ${alarmSettings.assetAudioPath}");
    await Alarm.set(
      alarmSettings: alarmSettings,
    );
  }

  Future<void> _cancelAlarm() async {
    final alarmId = widget.label.hashCode;
    try {
      await Alarm.stop(alarmId);
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

    widget.onSwitchChanged(isSwitched);
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
          inactiveThumbColor: Colors.grey,
        ),
      ),
    );
  }
}
