import 'package:comies_entities/src/action.dart';

class Notification {
  String message;
  Action action;

  Notification({this.message, Map<dynamic, dynamic> action}) {
    if (action != null) {
      this.action = Action(name: action['name'], href: action['href']);
    }
  }
}
