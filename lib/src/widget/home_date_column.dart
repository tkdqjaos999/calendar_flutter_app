import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateColumn extends StatelessWidget {
  final int date;

  const DateColumn({Key key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          date.toString(),
          style: GoogleFonts.nanumGothic(
            color: Colors.black,
          ),
        ),
      ),
    );;
  }
}
