import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onpress;
  const RoundButton({super.key, required this.title, required this.onpress});

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(12),
      child: MaterialButton(
        onPressed: onpress,
        color: Colors.cyan,
        height: MediaQuery.of(context).size.height * 0.06,
        minWidth: MediaQuery.of(context).size.height * 0.7,
        child: Center(
          child: Text(title, style: GoogleFonts.play(fontWeight: FontWeight.bold, fontSize: 22,),),
        ),
      ),
    );
  }
}
