import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class TextReadexpro extends StatelessWidget {
  final String title;
  final double textSize; // กำหนด textSize เป็นตัวแปรอินสแตนซ์
  final String hexcolor;

  const TextReadexpro({
    super.key,
    required this.title,
    required this.textSize,
    required this.hexcolor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.readexPro(
        textStyle: TextStyle(
          fontSize: textSize,
          color: HexColor(hexcolor),
          letterSpacing: 0.0,
        ),
      ),
    );
  }
}
