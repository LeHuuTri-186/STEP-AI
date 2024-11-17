import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_ai/shared/styles/colors.dart';

class AppBarThemeData {
  static AppBarTheme get lightTheme => AppBarTheme(
    backgroundColor: TColor.doctorWhite,
  );

  static AppBarTheme get darkTheme => AppBarTheme(
    backgroundColor: TColor.slate,
  );
}