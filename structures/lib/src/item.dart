import 'package:comies_entities/src/order.dart';
import 'package:comies_entities/src/product.dart';

class Item {
  int id;
  Order order;
  Product product;
  double quantity;
  double discount;
  int group;
}
