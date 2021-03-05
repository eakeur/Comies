import 'dart:collection';

import 'package:flutter/widgets.dart';

class MainController extends ChangeNotifier {



  List<Widget> _actionsOnPage = [];
  UnmodifiableListView<Widget> get actionsOnPage => _actionsOnPage;

  void addActions(List<Widget> widgets){
    _actionsOnPage.addAll(widgets);
    notifyListeners();
  }


}