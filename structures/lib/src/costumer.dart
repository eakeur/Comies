import 'package:comies_entities/src/address.dart';
import 'package:comies_entities/src/order.dart';
import 'package:comies_entities/src/phone.dart';

class Costumer {
  int id;
  String name;
  List<Phone> phones;
  List<Address> addresses;
  List<Order> orders;
  bool active;
}
