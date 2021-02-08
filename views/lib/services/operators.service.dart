import 'package:comies/services/general.service.dart';
import 'package:comies_entities/comies_entities.dart';

class OperatorsService extends GeneralService<Operator> {
  dynamic _context;

  OperatorsService() {
    this.path = 'operators';
  }

  void setContext(dynamic context) {
    this._context = context;
  }

  Future<List<Operator>> getOperators(Operator filter) async {
    Response res;
    try {
      List<Operator> prods = [];
      res = await super
          .get(query: super.getQueryString(_serializeProduct(filter)));
      if (!(res.data is List)) {
        throw new Exception();
      } else {
        for (var item in res.data) {
          prods.add(_deserializeMap(item));
        }
      }
      return prods;
    } catch (e) {
      notify(res, _context);
      return [];
    }
  }

  Future<Operator> getById(int id) async {
    Response res;
    try {
      res = await super.getOne(id);
      if (res.data == null) throw Exception;
      return _deserializeMap(res.data);
    } catch (e) {
      notify(res, _context);
      return new Operator();
    }
  }

  Future<void> removeOperator(int id) async {
    Response res;
    try {
      res = await super.delete(id);
      notify(res, _context);
    } catch (e) {
      notify(res, _context);
    }
  }

  Future<void> addOperator(Operator operator) async {
    Response res;
    try {
      res = await super.add(_serializeProduct(operator));
      notify(res, _context);
    } catch (e) {
      notify(res, _context);
    }
  }

  Future<void> updateOperator(Operator operator) async {
    Response res;
    try {
      res = await super.update(_serializeProduct(operator));
      notify(res, _context);
    } catch (e) {
      notify(res, _context);
    }
  }

  Operator _deserializeMap(dynamic map) {
    try {
      Operator op = new Operator();
      if (map is Map && map != null) {
        op.id = map['id'];
        op.name = map['name'];
        op.profile = new Profile();
        if (map['profile'] != null){

          op.profile.name = map['profile']['name'];

          op.profile.canAddProducts = map['profile']['canAddProducts'];
          op.profile.canGetProducts = map['profile']['canGetProducts'];
          op.profile.canUpdateProducts = map['profile']['canUpdateProducts'];
          op.profile.canRemoveProducts = map['profile']['canRemoveProducts'];

          op.profile.canAddCostumers = map['profile']['canAddCostumers'];
          op.profile.canGetCostumers = map['profile']['canGetCostumers'];
          op.profile.canUpdateCostumers = map['profile']['canUpdateCostumers'];
          op.profile.canRemoveCostumers = map['profile']['canRemoveCostumers'];

          op.profile.canAddOrders = map['profile']['canAddOrders'];
          op.profile.canGetOrders= map['profile']['canGetOrders'];
          op.profile.canUpdateOrders = map['profile']['canUpdateOrders'];
          op.profile.canRemoveOrders = map['profile']['canRemoveOrders'];

          op.profile.canAddProducts = map['profile']['canAddProducts'];
          op.profile.canGetProducts = map['profile']['canGetProducts'];
          op.profile.canUpdateProducts = map['profile']['canUpdateProducts'];
          op.profile.canRemoveProducts = map['profile']['canRemoveProducts'];

          op.profile.canAddStores = map['profile']['canAddStores'];
          op.profile.canGetStores = map['profile']['canGetStores'];
          op.profile.canUpdateStores = map['profile']['canUpdateStores'];
          op.profile.canRemoveStores = map['profile']['canRemoveStores'];
        }
        op.active = map["active"];
        op.orders = map['orders'];
      }
      return op;
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> _serializeProduct(Operator op) {
    try {
      return {
        if (op.id != null) "id": op.id,
        if (op.name != null) "name": op.name,
        if (op.active != null) "active": op.active,
        if (op.orders != null) "orders": op.orders,
        if (op.partner != null) "partner": op.partner
      };
    } catch (e) {
      throw e;
    }
  }

  Operator createProduct() {
    return new Operator();
  }
}
