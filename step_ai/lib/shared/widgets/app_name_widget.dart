import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppNameWidget extends StatelessWidget {
  AppNameWidget({
    super.key,
    this.color = Colors.white
  });

  late Color color;

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(
        style: GoogleFonts.varelaRound(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 25),
        children: [
          TextSpan(
              text: "STEP",
              style: GoogleFonts.varelaRound(
                color: color,
              )),
          TextSpan(
            text: " ",
            style: GoogleFonts.jetBrainsMono(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 15),
          ),
          TextSpan(text: "AI",
              style: GoogleFonts.aBeeZee(
                  color: color,
                  fontStyle: FontStyle.italic,
                  fontSize: 30)
          ),
        ]));
  }
}
