import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppNameWidget extends StatelessWidget {
  const AppNameWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(
        style: GoogleFonts.jetBrainsMono(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: MediaQuery.of(context).size.width * 0.05),
        children: [
          TextSpan(
              text: "STEP",
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white,
              )),
          TextSpan(
            text: " ",
            style: GoogleFonts.jetBrainsMono(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: MediaQuery.of(context).size.width * 0.01),
          ),
          TextSpan(text: "AI",
              style: GoogleFonts.jetBrainsMono(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: MediaQuery.of(context).size.width * 0.07)
          ),
        ]));
  }
}
