import 'dart:async';
import 'package:flutter/material.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Duration _selectedDuration = Duration(hours: 0);
  Duration _remainingDuration = Duration(hours: 0);
  Timer? _timer;
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isTimerRunning = false;

  Future<void> _selectDuration() async {
    final Duration? picked = await showDurationPicker(
      context: context,
      initialTime: _selectedDuration,
    );

    if (picked != null && picked != _selectedDuration) {
      setState(() {
        _selectedDuration = picked;
        _remainingDuration = picked;
      });
    }
  }

  void _startTimer() {
    if (_selectedDuration.inSeconds > 0) {
      setState(() {
        _isTimerRunning = true;
      });

      _timer?.cancel(); // Cancel any existing timer

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_remainingDuration.inSeconds <= 0) {
          _timer?.cancel();
          _playSound();
        } else {
          setState(() {
            _remainingDuration = _remainingDuration - Duration(seconds: 1);
          });
        }
      });
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      // Optionally reset remaining duration to original
      _remainingDuration = _selectedDuration;
    });
  }

  void _playSound() async {
    // Load and play the sound
    await _audioPlayer
        .play(AssetSource('alarm1.mp3')); // Add your sound file to assets
    setState(() {
      _isTimerRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff12043e),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Timer',
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Selected Duration:',
                style: GoogleFonts.mulish(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _formatDuration(_remainingDuration),
                style: GoogleFonts.mulish(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              OutlinedButton(
                onPressed: _selectDuration,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: Color(0xff9e610a),
                      width: 2), // Border color and width
                  // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Select Duration',
                  style: GoogleFonts.mulish(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isTimerRunning ? _stopTimer : _startTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isTimerRunning
                      ? Colors.red
                      : const Color(0xff9e610a), // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _isTimerRunning ? 'Stop Timer' : 'Start Timer',
                  style: GoogleFonts.mulish(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
