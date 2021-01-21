import 'package:comies_entities/src/configuration.dart';
import 'package:comies_entities/src/operator.dart';
import 'package:comies_entities/src/product.dart';
import 'package:comies_entities/src/profile.dart';
import 'package:comies_entities/src/store.dart';

class Partner {
  /// The partner's database ID
  int id;

  /// The name of the partner (may be the business name too)
  String name;

  /// The list of stores under this partner's domain
  List<Store> stores;

  /// The list of products this partner sells
  List<Product> products;

  /// The profile types under this partner's domain
  List<Profile> profiles;

  /// Properties set to this partner
  List<Configuration> configurations;

  /// The operators under this partner domain
  List<Operator> operators;

  /// Check if the partner is active in our registers
  bool active;
}
