import 'dart:convert';

import 'package:comies/services/general.service.dart';
import 'package:comies_entities/comies_entities.dart';

class CostumersService extends GeneralService<Costumer> {
  dynamic _context;


  CostumersService() {
    this.path = 'costumers';
  }

  void setContext(dynamic context) {
    this._context = context;
  }

  Future<List<Costumer>> getCostumers(Costumer filter) async {
    Response res;
    try {
      List<Costumer> costm = [];
      res = await super
          .get(query: super.getQueryString(_serializeCostumer(filter)));
      if (!(res.data is List)) {
        throw new Exception();
      } else {
        for (var item in res.data) {
          costm.add(_deserializeMap(item));
        }
      }
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
      if (!res.success) throw Exception();
      else return jsonDecode(res.data);
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

  Future<void> removeCostumerPhone(int id) async {
    Response res;
    try {
      this.path = 'costumers/phones';
      res = await super.delete(id);
      this.path = 'costumers';
      notify(res, _context);
    } catch (e) {
      this.path = 'costumers';
      notify(res, _context);
    }
  }

  Future<void> removeCostumerAddress(int id) async {
    Response res;
    try {
      this.path = 'costumers/addresses';
      res = await super.delete(id);
      this.path = 'costumers';
      notify(res, _context);
    } catch (e) {
      this.path = 'costumers';
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
        costm.name = map['name'];
        costm.phones = [];
        costm.addresses = [];
        costm.orders = map['orders'];
        costm.active = map['active'];

        if (map['phones'] != null && map['phones'] is List){
          for (var phone in map['phones']){
            var p = new Phone();
            p.id = phone['id'];
            p.ddd = phone['ddd'].toString();
            p.number = phone['number'].toString();
            costm.phones.add(p);
          }
        }
        
        if (map['addresses'] != null && map['addresses'] is List){
          for (var addr in map['addresses']){
            var p = new Address();
            p.id = addr['id'];
            p.cep = addr['cep'];
            p.street = addr['street'];
            p.number = addr['number'];
            p.district = addr['district'];
            p.complement = addr['complement'];
            p.reference = addr['reference'];
            p.city = addr['city'];
            p.state = addr['state'];
            p.country = addr['country'];
            costm.addresses.add(p);
          }
        }
      }
      return costm;
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> _serializeCostumer(Costumer prod) {
    try {

      var addrs = prod.addresses != null && prod.addresses is List ? [
        for (var ad in prod.addresses) {
          "id": ad.id,
          "cep": ad.cep,
          "street": ad.street,
          "complement": ad.complement,
          "reference": ad.reference,
          "district": ad.district,
          "number": ad.number,
          "city": ad.city,
          "state": ad.state,
          "country": ad.country
        }
      ] : null;
      var phones = prod.phones != null && prod.phones is List ? [
        for (var p in prod.phones) {
          "id": p.id,
          "ddd": p.ddd,
          "number": p.number
        }
      ] : null;
      return {
        if (prod.id != null) "id": prod.id,
        if (prod.name != null) "name": prod.name,
        if (prod.phones != null) "phones": phones,
        if (prod.addresses != null) "addresses": addrs,
        if (prod.orders != null) "orders": prod.orders,
        if (prod.active != null) "active": prod.active,
      };
    } catch (e) {
      throw e;
    }
  }

  Costumer createProduct() {
    return new Costumer();
  }
}
