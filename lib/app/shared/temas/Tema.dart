import 'package:flutter/material.dart';

class Tema {
  static ThemeData getWhiteTema(BuildContext context) {
    bool darkMode = false;
    return ThemeData(
        brightness: darkMode ? Brightness.dark : Brightness.light,
        appBarTheme: AppBarTheme(elevation: 0),
        accentColor: getCorPadrao(),
        scaffoldBackgroundColor: darkMode ? Colors.black : Colors.white,
        primaryColor: darkMode ? Colors.black : Colors.white,
        inputDecorationTheme: InputDecorationTheme(
            labelStyle:
                TextStyle(color: darkMode ? Colors.white60 : Colors.black87)));
  }
}

Color getCorPadrao() {
  return Colors.blue;
}
