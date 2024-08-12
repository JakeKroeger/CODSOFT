import 'package:alarm_app/models/alarm_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alarm_app/models/clockpainter.dart';
import 'package:flutter_spinner_time_picker/flutter_spinner_time_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alarm_app/models/alarm.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Alarm> alarms = [];

  void _addAlarm(TimeOfDay time, String label) {
    setState(() {
      alarms.add(Alarm(time: time, label: label));
      alarms.sort((a, b) {
        // First, compare by hour
        int hourComparison = a.time.hour.compareTo(b.time.hour);

        // If hours are the same, compare by minute
        if (hourComparison == 0) {
          return a.time.minute.compareTo(b.time.minute);
        }

        // Otherwise, return the hour comparison result
        return hourComparison;
      });
    });
  }

  void _showAddAlarmDialog() {
    TimeOfDay selectedTime = TimeOfDay.now();
    String label = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Add Alarm',
                      style: GoogleFonts.paytoneOne(
                          textStyle: TextStyle(fontSize: 24)),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'Label',
                          labelStyle: GoogleFonts.paytoneOne()),
                      onChanged: (value) {
                        label = value;
                      },
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final TimeOfDay? picked = await showSpinnerTimePicker(
                          context,
                          initTime: selectedTime,
                          is24HourFormat: false,
                        );
                        if (picked != null) {
                          setState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Select Time',
                          style: GoogleFonts.paytoneOne(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel',
                              style: GoogleFonts.paytoneOne(
                                  textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ))),
                        ),
                        TextButton(
                          onPressed: () {
                            _addAlarm(selectedTime, label);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Add',
                            style: GoogleFonts.paytoneOne(
                              textStyle: TextStyle(
                                color: Colors.black,
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
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color(0xff12043e),
        appBar: AppBar(
          title: Text(
            'Alarm',
            style: GoogleFonts.paytoneOne(
                textStyle: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w400,
            )),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff12043e),
                Color.fromARGB(255, 70, 9, 184),
              ],
            ),
          ),
          child: Center(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 50), // Space between clocks
                    Container(
                      width: 200, // Fixed width
                      height: 200, // Fixed height
                      child: ClockWidget(size: 100),
                    ),
                    SizedBox(height: 20), // Space between clock and alarms

                    Expanded(
                      child: ListView.builder(
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
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: _showAddAlarmDialog,
                    child: Icon(Icons.add_alarm,
                        color: Colors.white, size: 30), // Icon
                    backgroundColor: Colors.purple,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
