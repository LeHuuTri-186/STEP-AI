import 'package:flutter/material.dart';
import 'package:step_ai/shared/styles/colors.dart';

class AppBarThemeData {
  static AppBarTheme get lightTheme => AppBarTheme(
    backgroundColor: TColor.doctorWhite,
    scrolledUnderElevation: 0.0,
  );

  static AppBarTheme get darkTheme => AppBarTheme(
    backgroundColor: TColor.slate,
    scrolledUnderElevation: 0.0,
  );
}