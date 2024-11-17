import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_ai/shared/styles/a_bee_zee_style.dart';
import 'package:step_ai/shared/styles/colors.dart';

import 'app_bar_theme.dart';
import 'bottom_nav_theme.dart';

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: TColor.doctorWhite,
      scaffoldBackgroundColor: TColor.doctorWhite,
      appBarTheme: AppBarThemeData.lightTheme,
      textTheme: TextTheme(
        titleLarge: ABeeZeeStyle.titleW800,
        displayLarge: GoogleFonts.aBeeZee(
            fontWeight: FontWeight.w800, fontSize: 40, color: TColor.squidInk,),
        displayMedium: GoogleFonts.aBeeZee(
            fontWeight: FontWeight.w800, fontSize: 30, color: TColor.squidInk,),
        headlineLarge: GoogleFonts.varelaRound(
            fontSize: 96, fontWeight: FontWeight.bold, color: TColor.squidInk,),
        headlineSmall: GoogleFonts.varelaRound(
            fontSize: 20, fontWeight: FontWeight.w600, color: TColor.squidInk,),
        bodyLarge: GoogleFonts.aBeeZee(
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.aBeeZee(fontSize: 13, color: TColor.petRock),
      ),
      bottomNavigationBarTheme: BottomNavThemeData.lightTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: TColor.royalBlue,
          textStyle: GoogleFonts.varelaRound(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: TColor.doctorWhite,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}
