import 'package:flutter/material.dart';
import 'package:alarm_app/models/alarm_tile.dart';
import 'package:alarm_app/models/clockpainter.dart';
import 'package:flutter_spinner_time_picker/flutter_spinner_time_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alarm_app/models/alarm.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Alarm> alarms = [];

  @override
  void initState() {
    super.initState();
  }

  void _addAlarm(TimeOfDay time, String label) {
    setState(() {
      alarms.add(Alarm(time: time, label: label));
      alarms.sort((a, b) {
        int hourComparison = a.time.hour.compareTo(b.time.hour);
        if (hourComparison == 0) {
          return a.time.minute.compareTo(b.time.minute);
        }
        return hourComparison;
      });
    });
  }

  void _showAddAlarmDialog() {
    TimeOfDay selectedTime = TimeOfDay.now();
    String label = '';
    String displayedTime = selectedTime.format(context);

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
                          const SizedBox(height: 20),
                          Text(
                            displayedTime,
                            style: GoogleFonts.mulish(
                              textStyle: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
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
                                  displayedTime = selectedTime.format(context);
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
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
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
                              TextButton(
                                onPressed: () {
                                  _addAlarm(selectedTime, label);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: const Color(0xff12043e),
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
                                  time: alarm.time,
                                  label: alarm.label,
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
