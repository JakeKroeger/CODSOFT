import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StopwatchPage extends StatefulWidget {
  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  String _formattedTime = '00:00:00';
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(Duration(milliseconds: 30), _updateTime);
  }

  void _updateTime(Timer timer) {
    if (_stopwatch.isRunning) {
      setState(() {
        _formattedTime = _formatDuration(_stopwatch.elapsed);
      });
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    final milliseconds = duration.inMilliseconds % 1000 ~/ 10;
    return '${_twoDigits(minutes)}:${_twoDigits(seconds)}:${_twoDigits(milliseconds)}';
  }

  String _twoDigits(int value) {
    if (value >= 10) return '$value';
    return '0$value';
  }

  void _startStopwatch() {
    setState(() {
      _stopwatch.start();
      _isRunning = true;
    });
  }

  void _stopStopwatch() {
    setState(() {
      _stopwatch.stop();
      _isRunning = false;
    });
  }

  void _resetStopwatch() {
    setState(() {
      _stopwatch.reset();
      _formattedTime = '00:00:00';
      _isRunning = false;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Stopwatch',
          style: GoogleFonts.mulish(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        backgroundColor: const Color(0xff171717),
        elevation: 0,
        centerTitle: true,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _formattedTime,
                style: GoogleFonts.mulish(
                  textStyle: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _isRunning ? null : _startStopwatch,
                    child: Text(
                      'Start',
                      style: GoogleFonts.mulish(
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff9e610a),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _isRunning ? _stopStopwatch : null,
                    child: Text(
                      'Stop',
                      style: GoogleFonts.mulish(
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff9e610a),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: !_isRunning ? _resetStopwatch : null,
                    child: Text(
                      'Reset',
                      style: GoogleFonts.mulish(
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff9e610a),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
