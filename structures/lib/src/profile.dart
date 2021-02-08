import 'package:comies_entities/comies_entities.dart';

/// A group of settings that will allow or disallow operators to do things
class Profile {
  ///The profile id
  int id;

  ///The name of the profile setting
  String name;

  bool canAddOrders;

  bool canAddProducts;

  bool canAddCostumers;

  bool canAddStores;

  bool canUpdateOrders;

  bool canUpdateProducts;

  bool canUpdateCostumers;

  bool canUpdateStores;

  bool canGetOrders;

  bool canGetProducts;

  bool canGetCostumers;

  bool canGetStores;

  bool canRemoveOrders;

  bool canRemoveProducts;

  bool canRemoveCostumers;

  bool canRemoveStores;

  Partner partner;

  List<Operator> operators;
}
