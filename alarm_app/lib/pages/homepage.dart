import 'dart:io';
import 'package:alarm_app/pages/stopwatch.dart';
import 'package:alarm_app/pages/timer.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:alarm_app/models/alarm_tile.dart';
import 'package:alarm_app/models/clockpainter.dart';
import 'package:flutter_spinner_time_picker/flutter_spinner_time_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alarm_app/models/alarm.dart';
import 'package:alarm/alarm.dart' as alarmPlugin;

Widget _bottomNavItem({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Color(0xffae6a08),
          size: 30,
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: GoogleFonts.mulish(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ),
  );
}

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<AlarmObject> alarms = [];
  AudioPlayer audioPlayer = AudioPlayer();
  String previewPlaying = ''; // Track which preview is currently playing

  @override
  void initState() {
    super.initState();
    _initializeAlarms();
  }

  // Play the preview of the selected tune
  Future<void> _playPreview(String path) async {
    if (previewPlaying.isNotEmpty) {
      // Stop the currently playing preview
      await audioPlayer.stop();
    }

    // Set the new preview
    previewPlaying = path;

    await audioPlayer.play(AssetSource(path.toLowerCase()));
  }

  // Check if the label is unique
  bool _isLabelUnique(String label) {
    return alarms.every((alarm) => alarm.label != label);
  }

  // Initialize the alarms
  void _initializeAlarms() {
    for (var alarm in alarms) {
      if (alarm.isSwitched) {
        _setAlarm(alarm);
      } else {
        _cancelAlarm(alarm);
      }
    }
  }

  // Update the state of an alarm switch
  void _updateAlarmSwitchState(int index, bool isSwitched) {
    setState(() {
      alarms[index] = AlarmObject(
        time: alarms[index].time,
        label: alarms[index].label,
        isSwitched: isSwitched,
        tune: alarms[index].tune,
      );
      if (isSwitched) {
        _setAlarm(alarms[index]);
      } else {
        _cancelAlarm(alarms[index]);
      }
    });
  }

  // Cancel an alarm
  Future<void> _cancelAlarm(AlarmObject alarm) async {
    final alarmId = alarm.label.hashCode;
    try {
      await alarmPlugin.Alarm.stop(alarmId);
    } catch (e) {
      print("Error cancelling alarm: $e");
    }
  }

  // Set an alarm
  Future<void> _setAlarm(AlarmObject alarm) async {
    final now = DateTime.now();
    DateTime alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      alarm.time.hour,
      alarm.time.minute,
    );

    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(Duration(days: 1));
    }

    final alarmId = alarm.label.hashCode;

    final alarmSettings = alarmPlugin.AlarmSettings(
      id: alarmId,
      dateTime: alarmTime,
      assetAudioPath: 'assets/${alarm.tune.toLowerCase()}',
      loopAudio: true,
      vibrate: true,
      volume: 0.8,
      fadeDuration: 3.0,
      notificationTitle: alarm.time.format(context),
      notificationBody: alarm.label,
      enableNotificationOnKill: Platform.isAndroid,
    );

    await alarmPlugin.Alarm.set(
      alarmSettings: alarmSettings,
    );
  }

  // Add an alarm
  void _addAlarm(TimeOfDay time, String label, String tune) {
    if (label.isEmpty || !_isLabelUnique(label)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            label.isEmpty ? 'Label cannot be empty' : 'Label must be unique',
            style: GoogleFonts.mulish(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      alarms.add(
          AlarmObject(time: time, label: label, isSwitched: false, tune: tune));
      alarms.sort((a, b) {
        int hourComparison = a.time.hour.compareTo(b.time.hour);
        if (hourComparison == 0) {
          return a.time.minute.compareTo(b.time.minute);
        }
        return hourComparison;
      });
    });
  }

  // Show the dialog to add an alarm
  void _showAddAlarmDialog() {
    TimeOfDay selectedTime = TimeOfDay.now();
    String label = '';
    String displayedTime = selectedTime.format(context);

    // List of available tunes
    List<String> tunes = [
      'alarm1.mp3',
      'CHIMES.mp3',
      'Clock1.mp3',
      'Clock2.mp3',
      'DigitalAlarm1.mp3',
      'DigitalAlarm2.mp3',
    ];

    // Initialize selected tune
    String selectedTune = tunes[1];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                color: const Color(0xff171717),
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Add Alarm',
                            style: GoogleFonts.mulish(
                              textStyle: const TextStyle(
                                  fontSize: 24, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Row for time picker
                          Row(
                            children: [
                              // Display selected time
                              Text(
                                displayedTime,
                                style: GoogleFonts.mulish(
                                  textStyle: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Spacer(),

                              // Button to select time
                              GestureDetector(
                                onTap: () async {
                                  final TimeOfDay? picked =
                                      await showSpinnerTimePicker(
                                    context,
                                    initTime: selectedTime,
                                    is24HourFormat: false,
                                  );

                                  if (picked != null) {
                                    setModalState(() {
                                      selectedTime = picked;
                                      displayedTime =
                                          selectedTime.format(context);
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff9e610a),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Select Time',
                                    style: GoogleFonts.mulish(
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Label text field
                          TextField(
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              labelText: 'Label',
                              labelStyle: GoogleFonts.mulish(),
                            ),
                            style: const TextStyle(
                                color: Colors.white), // Make typing white
                            onChanged: (value) {
                              label = value;
                            },
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Choose Tune -',
                                style: GoogleFonts.mulish(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _playPreview(selectedTune);
                                },
                                icon: Icon(
                                  Icons.play_arrow,
                                  color: Colors.blue[300],
                                ),
                              ),

                              // Dropdown List of Tunes
                              DropdownButton<String>(
                                dropdownColor: const Color(
                                    0xff000000), // Background color of the dropdown menu
                                value: selectedTune,
                                onChanged: (String? newValue) {
                                  setModalState(() {
                                    selectedTune = newValue!;
                                  });
                                  setState(() {
                                    selectedTune = newValue!;
                                  });
                                },

                                items: tunes.map<DropdownMenuItem<String>>(
                                    (String tune) {
                                  return DropdownMenuItem<String>(
                                    value: tune,
                                    child: Text(
                                      tune
                                          .split('/')
                                          .last
                                          .replaceAll('.mp3', ''),
                                      style: GoogleFonts.mulish(
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(width: 16),
                            ],
                          ),
                          const SizedBox(height: 70),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Cancel button
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.mulish(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              // Add button
                              TextButton(
                                onPressed: () {
                                  _addAlarm(selectedTime, label, selectedTune);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Add',
                                  style: GoogleFonts.mulish(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Delete an alarm
  void _deleteAlarm(String label) {
    setState(() {
      final alarmToDelete = alarms.firstWhere((alarm) => alarm.label == label);
      alarmPlugin.Alarm.stop(alarmToDelete.label.hashCode);
      alarms.remove(alarmToDelete);
    });
  }

  void updateAlarm(
      String oldLabel, TimeOfDay newTime, String newLabel, String newTune) {
    setState(() {
      final alarmIndex = alarms.indexWhere((alarm) => alarm.label == oldLabel);
      alarmPlugin.Alarm.stop(alarms[alarmIndex].label.hashCode);
      if (alarmIndex != -1) {
        alarms[alarmIndex] = AlarmObject(
          time: newTime,
          label: newLabel,
          isSwitched: alarms[alarmIndex].isSwitched,
          tune: newTune,
        );
        if (alarms[alarmIndex].isSwitched) {
          _setAlarm(alarms[alarmIndex]);
        }
      }
    });
  }

  // Show the dialog to edit an alarm
  void _showEditAlarmDialog(AlarmObject alarm) {
    TimeOfDay selectedTime = alarm.time;
    String label = alarm.label;
    String displayedTime = selectedTime.format(context);

    // List of available tunes
    List<String> tunes = [
      'alarm1.mp3',
      'CHIMES.mp3',
      'Clock1.mp3',
      'Clock2.mp3',
      'DigitalAlarm1.mp3',
      'DigitalAlarm2.mp3',
    ];

    // Initialize selected tune
    String selectedTune = alarm.tune;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                color: const Color(0xff171717),
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Edit Alarm',
                            style: GoogleFonts.mulish(
                              textStyle: const TextStyle(
                                  fontSize: 24, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Row for time picker
                          Row(
                            children: [
                              // Display selected time
                              Text(
                                displayedTime,
                                style: GoogleFonts.mulish(
                                  textStyle: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Spacer(),

                              // Button to select time
                              GestureDetector(
                                onTap: () async {
                                  final TimeOfDay? picked =
                                      await showSpinnerTimePicker(
                                    context,
                                    initTime: selectedTime,
                                    is24HourFormat: false,
                                  );

                                  if (picked != null) {
                                    setModalState(() {
                                      selectedTime = picked;
                                      displayedTime =
                                          selectedTime.format(context);
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff9e610a),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Select Time',
                                    style: GoogleFonts.mulish(
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Label text field
                          TextField(
                            controller: TextEditingController(text: label),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              labelText: 'Label',
                              labelStyle: GoogleFonts.mulish(),
                            ),
                            style: const TextStyle(
                                color: Colors.white), // Make typing white
                            onChanged: (value) {
                              label = value;
                            },
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Choose Tune -',
                                style: GoogleFonts.mulish(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _playPreview(selectedTune);
                                },
                                icon: Icon(
                                  Icons.play_arrow,
                                  color: Colors.blue[300],
                                ),
                              ),

                              // Dropdown List of Tunes
                              DropdownButton<String>(
                                dropdownColor: const Color(
                                    0xff000000), // Background color of the dropdown menu
                                value: selectedTune,
                                onChanged: (String? newValue) {
                                  setModalState(() {
                                    selectedTune = newValue!;
                                  });
                                  setState(() {
                                    selectedTune = newValue!;
                                  });
                                },

                                items: tunes.map<DropdownMenuItem<String>>(
                                    (String tune) {
                                  return DropdownMenuItem<String>(
                                    value: tune,
                                    child: Text(
                                      tune
                                          .split('/')
                                          .last
                                          .replaceAll('.mp3', ''),
                                      style: GoogleFonts.mulish(
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(width: 16),
                            ],
                          ),
                          const SizedBox(height: 70),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Delete button
                              TextButton(
                                onPressed: () {
                                  _deleteAlarm(alarm.label);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Delete',
                                  style: GoogleFonts.mulish(
                                    textStyle: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              // Update button
                              TextButton(
                                onPressed: () {
                                  updateAlarm(alarm.label, selectedTime, label,
                                      selectedTune);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Update',
                                  style: GoogleFonts.mulish(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: const Color(0xff12043e),

        // App Bar
        appBar: AppBar(
          title: Text(
            'Alarm',
            style: GoogleFonts.mulish(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          backgroundColor: const Color(0xff171717),
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Color(0xffae6a08)),
              onPressed: () {
                _showAddAlarmDialog();
              },
            ),
          ],
        ),

        // Bottom Navigation Bar
        bottomNavigationBar: BottomAppBar(
          color: const Color(0xff171717),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _bottomNavItem(
                  icon: Icons.alarm,
                  label: 'Alarm',
                  onTap: () {
                    // Navigate to Alarm page
                  },
                ),
                _bottomNavItem(
                  icon: Icons.timer,
                  label: 'Timer',
                  onTap: () {
                    // Navigate to Timer page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimerPage(),
                      ),
                    );
                  },
                ),
                _bottomNavItem(
                  icon: Icons.watch,
                  label: 'Stopwatch',
                  onTap: () {
                    // Navigate to Stopwatch page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StopwatchPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // Body
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff000000),
                Color(0xff0d0d0d),
              ],
            ),
          ),
          child: Center(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Container(
                      width: 200,
                      height: 200,
                      child: ClockWidget(size: 100),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: alarms.isEmpty
                          ? Center(
                              child: Text(
                                'No alarms',
                                style: GoogleFonts.mulish(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: alarms.length,
                              itemBuilder: (context, index) {
                                final alarm = alarms[index];
                                return AlarmTile(
                                  alarm: alarms[index],
                                  time: alarm.time,
                                  label: alarm.label,
                                  OnEditAlarm: () =>
                                      _showEditAlarmDialog(alarm),
                                  isSwitched: alarm.isSwitched,
                                  tune: alarm.tune,
                                  onSwitchChanged: (isSwitched) {
                                    _updateAlarmSwitchState(index, isSwitched);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
