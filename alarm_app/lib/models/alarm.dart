import 'package:flutter/material.dart';

class AlarmObject {
  final TimeOfDay time;
  final String label;
  bool isSwitched = false;
  final String tune;

  AlarmObject(
      {required this.time,
      required this.label,
      this.isSwitched = false,
      required this.tune});
}
