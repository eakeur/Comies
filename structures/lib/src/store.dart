import 'package:comies_entities/src/operator.dart';
import 'package:comies_entities/src/order.dart';

import '../comies_entities.dart';

class Store {
  ///The store id
  int id;

  /// The name of the store
  String name;

  /// The partner that this store is under
  Partner partner;

  /// Orders that this store has
  List<Order> orders;

  /// The operators that has access to this store
  List<Operator> operators;
}
