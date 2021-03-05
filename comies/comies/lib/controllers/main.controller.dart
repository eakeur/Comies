import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Color, Colors;

class MainController extends ChangeNotifier {

  Color _mainColor = Colors.deepOrange; Color get mainColor => _mainColor;
  Color _subColor = Colors.yellow[800]; Color get subColor => _subColor;
  
  void setMainColor(Color color){_mainColor = color; notifyListeners();}
  void setSubColor(Color color){_subColor = color; notifyListeners();}
  
}