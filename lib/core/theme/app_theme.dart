import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Color(0xFF075E54),
      secondary: Color(0xFF25D366),
      background: Color.fromARGB(255, 219, 211, 211),
    ),
    fontFamily: 'Roboto',
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF075E54),
      secondary: Color(0xFF25D366),
      background: Color(0xFF121B22),
    ),
    fontFamily: 'Roboto',
    useMaterial3: true,
  );
}
