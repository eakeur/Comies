import 'package:flutter/material.dart';

ThemeData mainTheme(Brightness brightness) {
  return ThemeData(
    brightness: brightness,
    primarySwatch: Colors.deepOrange,
    primaryColor: Colors.deepOrange,
    appBarTheme: AppBarTheme(color: Colors.deepOrange),
    accentColor: Colors.yellow[800],
    accentColorBrightness: Brightness.light,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        hoverColor: Colors.deepOrange, focusColor: Colors.deepOrange),
    primaryColorDark: Colors.deepOrange[800],
    inputDecorationTheme: InputDecorationTheme(
      border: UnderlineInputBorder(),
      contentPadding: EdgeInsets.only(
        left: 15,
        bottom: 5,
      ),
      focusColor: Colors.yellow[800],
    ),
    toggleButtonsTheme:
        ToggleButtonsThemeData(selectedColor: Colors.yellow[800]),
  );
}
