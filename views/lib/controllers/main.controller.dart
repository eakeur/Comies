import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class MainController extends ChangeNotifier {



  List<Widget> _actionsOnPage = [];
  UnmodifiableListView<Widget> get actionsOnPage => _actionsOnPage;
  BuildContext _context;

  String _actualRoute = "/";
  String get actualRoute => _actualRoute;

  void addActions(List<Widget> widgets){
    _actionsOnPage.addAll(widgets);
    notifyListeners();
  }


  void setActualRoute(String route, context){
    _actualRoute = route;
    Navigator.of(context).pushNamed(actualRoute);
  }



}