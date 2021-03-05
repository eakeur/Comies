import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class ButtonTheme {
  Color background;
  Gradient gradient;
  Color fontColor;
  double fontSize;

  static ButtonTheme get success {
    var theme = new ButtonTheme();
    theme.background = Colors.green[700];
    theme.fontColor = Colors.white;
    return theme;
  }

  static ButtonTheme get disabled {
    var theme = new ButtonTheme();
    theme.background = Colors.grey[400];
    theme.fontColor = Colors.grey[300];
    return theme;
  }

  static ButtonTheme get simple {
    var theme = new ButtonTheme();
    theme.background = Colors.grey[400];
    theme.fontColor = Colors.grey[300];
    return theme;
  }
}

class TextButton extends StatelessWidget {

  final String text;
  final Function onTap;
  final ButtonTheme buttonTheme;

  TextButton({this.text, this.onTap, this.buttonTheme});
  
  @override
  Widget build(BuildContext context){

    var theme = onTap != null
      ? buttonTheme != null ? buttonTheme : ButtonTheme.simple
      : ButtonTheme.disabled;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        child: Text(text.toUpperCase(), style: TextStyle(color: theme.fontColor)),
        alignment: Alignment.center,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: theme.background,
          gradient: theme.gradient,
          borderRadius: BorderRadius.circular(100)
        ),

      ),
    );
  }
}

