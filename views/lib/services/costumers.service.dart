import 'package:comies/services/general.service.dart';
import 'package:comies_entities/comies_entities.dart';

class CostumersService extends GeneralService<Costumer> {
  dynamic _context;

  Costumer costumer = new Costumer();
  List<Costumer> costumers = [];

  CostumersService() {
    this.path = 'costumers';
  }

  void setContext(dynamic context) {
    this._context = context;
  }

  Future<List<Costumer>> getCostumers() async {
    Response res;
    try {
      List<Costumer> costm = [];
      res = await super
          .get(query: super.getQueryString(_serializeCostumer(costumer)));
      if (!(res.data is List)) {
        throw new Exception();
      } else {
        for (var item in res.data) {
          costm.add(_deserializeMap(item));
        }
      }
      costumers = costm;
      return costm;
    } catch (e) {
      notify(res, _context);
      return [];
    }
  }

  Future<Costumer> getById(int id) async {
    Response res;
    try {
      res = await super.getOne(id);
      if (res.data == null) throw Exception;
      return _deserializeMap(res.data);
    } catch (e) {
      notify(res, _context);
      return null;
    }
  }

  Future<dynamic> getAddressInfo(String code) async {
    try {
      var res = await super.getExternal("https://viacep.com.br/ws/$code/json/");
      if (res == null) throw Exception;
    } catch (e) {
      return null;
    }
  }

  Future<void> removeCostumer(int id) async {
    Response res;
    try {
      res = await super.delete(id);
      notify(res, _context);
    } catch (e) {
      notify(res, _context);
    }
  }

  Future<void> addCostumer(Costumer product) async {
    Response res;
    try {
      res = await super.add(_serializeCostumer(product));
      notify(res, _context);
    } catch (e) {
      notify(res, _context);
    }
  }

  Future<void> updateCostumer(Costumer product) async {
    Response res;
    try {
      res = await super.update(_serializeCostumer(product));
      notify(res, _context);
    } catch (e) {
      notify(res, _context);
    }
  }

  Costumer _deserializeMap(dynamic map) {
    try {
      Costumer costm = new Costumer();
      if (map is Map && map != null) {
        costm.id = map['id'];
        costm.firstName = map['firstName'];
        costm.lastName = map['lastName'];
        costm.phones = map['phones'];
        costm.addresses = map["addresses"];
        costm.orders = map['orders'];
        costm.active = map['active'];
      }
      return costm;
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> _serializeCostumer(Costumer prod) {
    try {
      return {
        if (prod.id != null) "id": prod.id,
        if (prod.firstName != null) "firstName": prod.firstName,
        if (prod.lastName != null) "lastName": prod.lastName,
        if (prod.phones != null) "phones": prod.phones,
        if (prod.addresses != null) "addresses": prod.active,
        if (prod.orders != null) "orders": prod.orders,
        if (prod.active != null) "active": prod.active,
      };
    } catch (e) {
      throw e;
    }
  }

  void addProperty(Function(Costumer) additionProcedure) {
    additionProcedure(costumer);
  }

  Costumer createProduct() {
    return new Costumer();
  }
}
