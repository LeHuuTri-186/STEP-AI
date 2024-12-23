import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_ai/shared/styles/horizontal_spacing.dart';

class AppNameWidget extends StatelessWidget {
  AppNameWidget({super.key, this.color = Colors.white, this.name = 'lib/core/assets/imgs/step-ai-logo.png'});

  final Color color;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: Image.asset(
            name,
            fit: BoxFit.contain,
          ),
        ),
        HSpacing.sm,
        Text.rich(
          TextSpan(
            style: GoogleFonts.varelaRound(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 25,
            ),
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
                  fontSize: 15,
                ),
              ),
              TextSpan(
                text: "AI",
                style: GoogleFonts.aBeeZee(
                  color: color,
                  fontStyle: FontStyle.italic,
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
