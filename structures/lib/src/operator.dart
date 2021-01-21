import 'package:comies_entities/comies_entities.dart';
import 'package:comies_entities/src/order.dart';
import 'package:comies_entities/src/profile.dart';
import 'package:comies_entities/src/store.dart';

class Operator {
  int id;
  String firstName;
  String lastName;
  String identification;
  String password;
  DateTime lastLogin;
  Profile profile;
  Store store;
  Partner partner;
  List<Order> orders;
  bool active;
}
