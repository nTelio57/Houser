import 'package:flutter/material.dart';

class AppColors{
  static const Color backgroundColor = Color(0xFFE7F5FA);

  static const int primaryColorHex = 0xFF0099CC;
  static const Color primaryColor = Color(primaryColorHex);
  static const MaterialColor primaryPalette = MaterialColor(primaryColorHex, <int, Color>{
    50: Color(0xFFE0F3F9),
    100: Color(0xFFB3E0F0),
    200: Color(0xFF80CCE6),
    300: Color(0xFF4DB8DB),
    400: Color(0xFF26A8D4),
    500: Color(primaryColorHex),
    600: Color(0xFF0091C7),
    700: Color(0xFF0086C0),
    800: Color(0xFF007CB9),
    900: Color(0xFF006BAD),
  });

  static const int accentColorHex = 0xFFA4D7FF;
  static const Color accentColor = Color(accentColorHex);
  static const MaterialColor accentPalette = MaterialColor(accentColorHex, <int, Color>{
    100: Color(0xFFD7EDFF),
    200: Color(accentColorHex),
    400: Color(0xFF71C0FF),
    700: Color(0xFF58B5FF),
  });
}