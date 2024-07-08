import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Textt extends StatelessWidget {
  String? text;
  double? fontsize;
   Textt({super.key, required this.text, required this.fontsize});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text!,style: GoogleFonts.play(fontSize:fontsize, fontWeight: FontWeight.bold)));
  }
}
