import 'package:flutter/material.dart';

class Alarm {
  final TimeOfDay time;
  final String label;
  bool isSwitched = false;
  final String tune;

  Alarm(
      {required this.time,
      required this.label,
      this.isSwitched = false,
      required this.tune});
}
