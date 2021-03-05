import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData mainTheme(Brightness brightness) {
  return ThemeData(
    brightness: brightness,
    primarySwatch: Colors.deepOrange,
    primaryColor: Colors.deepOrange,
    fontFamily: "Poppins",
    appBarTheme: AppBarTheme(color: Colors.deepOrange, centerTitle: true, elevation: 20, systemOverlayStyle: SystemUiOverlayStyle.dark),
    accentColor: Colors.yellow[800],
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size(90, 45)),
        visualDensity: VisualDensity.comfortable,
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)))
      )
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size(90, 45)),
        visualDensity: VisualDensity.comfortable,
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0), side: BorderSide(color: Colors.deepOrange)))
      )
    ),
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



ButtonStyle successButton = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Colors.green[600])
);

ButtonStyle dangerButton = ButtonStyle(
  shape: MaterialStateProperty.all(RoundedRectangleBorder(side: BorderSide(color: Colors.red[600]))),
  backgroundColor: MaterialStateProperty.all(Colors.red[600])
);
