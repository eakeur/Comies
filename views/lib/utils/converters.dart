import 'package:comies_entities/comies_entities.dart';

  Product deserializeProductMap(Map<String, dynamic> map) {
    try {
      Product prod = new Product();
      if (map is Map && map != null) {
        prod.id = map['id'];
        prod.name = map['name'];
        prod.code = map['code'];
        prod.min = map['min'].toDouble();
        prod.active = map["active"];
        prod.orders = map['orders'];
        prod.price = map['price'].toDouble();
        prod.unity = Unity.values[map['unity']];
        prod.partner = map["partner"];
      }
      return prod;
    } catch (e) {
      throw e;
    }
  }

  Costumer deserializeCostumerMap(Map<String, dynamic> map) {
    try {
      Costumer costm = new Costumer();
      if (map is Map && map != null) {
        costm.id = map['id'];
        costm.name = map['name'];
        costm.phones = [];
        costm.addresses = [];
        costm.orders = map['orders'];
        costm.active = map['active'];
        if (map['phones'] != null && map['phones'] is List)
          for (var phone in map['phones'])costm.phones.add(deserializePhoneMap(phone)); 
        if (map['addresses'] != null && map['addresses'] is List)
          for (var addr in map['addresses']) costm.addresses.add(deserializeAddressMap(addr));
      }
      return costm;
    } catch (e) { throw e;}
  }

  Phone deserializePhoneMap(Map<String, dynamic> phone){
    try {
      var p = new Phone();
      p.id = phone['id'];
      p.ddd = phone['ddd'].toString();
      p.number = phone['number'].toString();
      return p;
    } catch (e) {
      throw e;
    }
  }

  Address deserializeAddressMap(Map<String, dynamic> addr){
    try {
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
      return p;
    } catch (e) {
      throw e;
    }
  }

  Profile deserializeProfileMap(Map<String, dynamic> map){
    try {
      Profile profile = new Profile();
      profile.name = map['name'];
      profile.canAddProducts = map['canAddProducts'];
      profile.canGetProducts = map['canGetProducts'];
      profile.canUpdateProducts = map['canUpdateProducts'];
      profile.canRemoveProducts = map['canRemoveProducts'];
      profile.canAddCostumers = map['canAddCostumers'];
      profile.canGetCostumers = map['canGetCostumers'];
      profile.canUpdateCostumers = map['canUpdateCostumers'];
      profile.canRemoveCostumers = map['canRemoveCostumers'];
      profile.canAddOrders = map['canAddOrders'];
      profile.canGetOrders= map['canGetOrders'];
      profile.canUpdateOrders = map['canUpdateOrders'];
      profile.canRemoveOrders = map['canRemoveOrders'];
      profile.canAddProducts = map['canAddProducts'];
      profile.canGetProducts = map['canGetProducts'];
      profile.canUpdateProducts = map['canUpdateProducts'];
      profile.canRemoveProducts = map['canRemoveProducts'];
      profile.canAddStores = map['canAddStores'];
      profile.canGetStores = map['canGetStores'];
      profile.canUpdateStores = map['canUpdateStores'];
      profile.canRemoveStores = map['canRemoveStores'];
      return profile;
    } catch (e) {throw e;}
  }

  Operator deserializeOperatorMap(Map<String, dynamic> map) {
    try {
      Operator op = new Operator();
      if (map is Map && map != null) {
        op.id = map['id'];
        op.name = map['name'];
        op.profile = new Profile();
        if (map['profile'] != null) op.profile = deserializeProfileMap(map['profile']);
        op.active = map["active"];
        op.orders = map['orders'];
      }
      return op;
    } catch (e) {throw e;}
  }

  Order deserializeOrderMap(Map<String, dynamic> map){
    try {
      Order op = new Order();
      op.id = map['id'];
      op.active = map["active"];
      op.address = map['address'] != null ? deserializeAddressMap(map['address']) : null;
      op.costumer = map['costumer'] != null ? deserializeCostumerMap(map['costumer']) : null;
      op.deliverType = DeliverType.values[map['deliverType']];
      op.items = [];
      if (map["items"] != null && map["items"] is List) map["items"].forEach((item) => op.items.add(deserializeItemMap(item)));
      op.operator = map["operator"] != null ? deserializeOperatorMap(map["operator"]) : null;
      op.payment = PaymentMethod.values[map['payment']];
      op.placed = DateTime.tryParse(map['placed']);
      op.price = map["price"];
      op.status = Status.values[map['status']];
      op.store = map["store"] != null ? null : null;
      return op;
    } catch (e) {throw e;}

  } 

  Item deserializeItemMap(Map<String, dynamic> map){
      try {
        Item op = new Item();
        op.id = map['id'];
        op.product = map["product"] != null ? deserializeProductMap(map["product"]) : null;
        op.discount = map['discount'];
        op.group = map['group'];
        op.order = map['order'];
        op.quantity = map['quantity'];
        return op;
    } catch (e) {throw e;}
  }




  Map<String, dynamic> serializeOrder(Order op){
    try {
      return {
        if (op.id != null) "id": op.id,
        if (op.active != null) "active": op.active,
        if (op.address != null) "address": serializeAddress(op.address),
        if (op.costumer != null) "costumer": serializeCostumer(op.costumer),
        if (op.deliverType != null) "deliverType": op.deliverType.index,
        if (op.items != null) "items": op.items.map((e) => serializeItem(e)).toList(),
        if (op.operator != null) "operator": serializeOperator(op.operator),
        if (op.payment != null) "payment": op.payment.index,
        if (op.placed != null) "placed": op.placed.toIso8601String(),
        if (op.price != null) "price": op.price,
        if (op.status != null) "status": op.status.index,
        if (op.store != null) "store": null,
      };
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> serializeItem(Item op){
    try {
      return {
        if (op.id != null) "id": op.id,
        if (op.discount != null) "discount": op.discount,
        if (op.group != null) "group": op.group,
        if (op.order != null) "order": serializeOrder(op.order),
        if (op.product != null) "product": serializeProduct(op.product),
        if (op.quantity != null) "quantity": op.quantity,
      };
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> serializeOperator(Operator op) {
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

  Map<String, dynamic> serializeAddress(Address addr){
    try {
      return {
          "id": addr.id,
          "cep": addr.cep,
          "street": addr.street,
          "complement": addr.complement,
          "reference": addr.reference,
          "district": addr.district,
          "number": addr.number,
          "city": addr.city,
          "state": addr.state,
          "country": addr.country
        };
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> serializePhone(Phone phone){
    try {
      return {
        "id": phone.id,
        "ddd": phone.ddd,
        "number": phone.number
      };
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> serializeCostumer(Costumer prod) {
    try {
      return {
        if (prod.id != null) "id": prod.id,
        if (prod.name != null) "name": prod.name,
        if (prod.phones != null) "phones": prod.phones != null && prod.phones is List ? [
          for (var p in prod.phones) serializePhone(p)
        ] : null,
        if (prod.addresses != null) "addresses": prod.addresses != null && prod.addresses is List ? [
          for (var ad in prod.addresses) serializeAddress(ad)
        ] : null,
        if (prod.orders != null) "orders": prod.orders,
        if (prod.active != null) "active": prod.active,
      };
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> serializeProduct(Product prod) {
    try {
      return {
        if (prod.id != null) "id": prod.id,
        if (prod.name != null) "name": prod.name,
        if (prod.code != null) "code": prod.code,
        if (prod.min != null) "min": prod.min,
        if (prod.active != null) "active": prod.active,
        if (prod.orders != null) "orders": prod.orders,
        if (prod.price != null) "price": prod.price,
        if (prod.unity != null) "unity": prod.unity.index,
        if (prod.partner != null) "partner": prod.partner
      };
    } catch (e) {
      throw e;
    }
  }