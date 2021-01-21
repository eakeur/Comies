import 'package:comies_entities/comies_entities.dart';
import 'package:comies_entities/src/enum.dart';
import 'package:comies_entities/src/order.dart';

class Product {
  int id;
  String name;
  String code;
  int min;
  Unity unity;
  double price;
  Partner partner;
  List<Order> orders;
  bool active;
}
