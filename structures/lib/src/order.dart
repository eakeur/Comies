import 'package:comies_entities/comies_entities.dart';
import 'package:comies_entities/src/costumer.dart';
import 'package:comies_entities/src/enum.dart';
import 'package:comies_entities/src/item.dart';
import 'package:comies_entities/src/store.dart';

import 'operator.dart';

class Order {
  int id;
  DateTime placed;
  Status status;
  DeliverType deliverType;
  PaymentMethod payment;
  Store store;
  Costumer costumer;
  Operator operator;
  List<Item> items;
  Address address;
  double price;
  bool active;
}
