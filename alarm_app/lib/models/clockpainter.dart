import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';

// This CustomPainter draws the clock hands based on the current time
class ClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = min(centerX, centerY);

    final now = DateTime.now();
    final hour = now.hour % 12;
    final minute = now.minute;
    final second = now.second;

    final paintFaceShadow = Paint()
      ..color =
          Colors.black.withOpacity(0.4) // Shadow color with some transparency
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6); // Soften the shadow

    // Draw shadow behind clock face
    final shadowRadius = radius * 1.1; // Slightly larger radius for shadow
    canvas.drawCircle(Offset(centerX, centerY), shadowRadius, paintFaceShadow);

    final paintFace = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX, centerY), radius, paintFace);

    final paintHands = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw hour hand
    final hourHandLength = radius * 0.5;
    final hourHandX = centerX +
        hourHandLength * cos((hour * 30 + minute / 2) * pi / 180 - pi / 2);
    final hourHandY = centerY +
        hourHandLength * sin((hour * 30 + minute / 2) * pi / 180 - pi / 2);
    canvas.drawLine(Offset(centerX, centerY), Offset(hourHandX, hourHandY),
        paintHands..strokeWidth = 4);

    // Draw minute hand
    final minuteHandLength = radius * 0.8;
    final minuteHandX =
        centerX + minuteHandLength * cos(minute * 6 * pi / 180 - pi / 2);
    final minuteHandY =
        centerY + minuteHandLength * sin(minute * 6 * pi / 180 - pi / 2);
    canvas.drawLine(Offset(centerX, centerY), Offset(minuteHandX, minuteHandY),
        paintHands..strokeWidth = 3);

    // Draw second hand
    final secondHandLength = radius * 0.9;
    final secondHandX =
        centerX + secondHandLength * cos(second * 6 * pi / 180 - pi / 2);
    final secondHandY =
        centerY + secondHandLength * sin(second * 6 * pi / 180 - pi / 2);
    canvas.drawLine(
        Offset(centerX, centerY),
        Offset(secondHandX, secondHandY),
        paintHands
          ..strokeWidth = 2
          ..color = Colors.purple);

    // Draw clock numbers
    final textStyle = GoogleFonts.poppins(
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );

    for (int i = 1; i <= 12; i++) {
      final angle = (i * 30) * pi / 180; // Convert hour to radians
      final x = centerX +
          (radius - 20) * cos(angle - pi / 2); // Position for the number
      final y = centerY +
          (radius - 20) * sin(angle - pi / 2); // Position for the number

      final textSpan = TextSpan(
        text: '$i',
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(canvas,
          Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// This widget displays an analog clock that updates every second

class ClockWidget extends StatefulWidget {
  final double size;

  ClockWidget({required this.size});

  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {}); // Trigger a rebuild every second
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.size, widget.size), // Use the dynamic size
      painter: ClockPainter(),
    );
  }
}
