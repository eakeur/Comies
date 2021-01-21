import 'package:comies_entities/src/costumer.dart';
import 'package:comies_entities/src/enum.dart';
import 'package:comies_entities/src/item.dart';
import 'package:comies_entities/src/store.dart';

import 'operator.dart';

class Order {
  int number;
  DateTime placed;
  Status status;
  Store store;
  Costumer costumer;
  Operator operator;
  List<Item> items;
  double price;
  bool active;
}
