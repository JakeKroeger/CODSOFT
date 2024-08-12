import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlarmTile extends StatefulWidget {
  final DateTime time;
  final String label;

  const AlarmTile({
    required this.time,
    required this.label,
  });

  @override
  State<AlarmTile> createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xff5215fc),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          title: Text(
            '${widget.time.hour > 12 ? widget.time.hour % 12 : widget.time.hour}:${widget.time.minute} ${widget.time.hour > 12 ? 'PM' : 'AM'}',
            style: GoogleFonts.mulish(
              color: Color(0xFFECECEC),
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            widget.label,
            style: GoogleFonts.mulish(
              color: Color(0xFFECECEC),
              fontSize: 16.0,
              fontWeight: FontWeight.w300,
            ),
          ),
          trailing: Icon(
            Icons.toggle_off_rounded,
            size: 50,
            color: Color.fromARGB(115, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}
