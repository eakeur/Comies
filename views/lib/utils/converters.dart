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
        op.partner = map['partner'] != null ? deserializePartnerMap(map['partner']) : null;
        op.store = map['store'] != null ? deserializeStoreMap(map['store']) : null;
        op.orders = [];
        if (map['orders'] != null && map['orders'] is List) map['orders'].forEach((e) => op.orders.add(deserializeOrderMap(e)));
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
      op.placed = map['placed'] != null ? DateTime.tryParse(map['placed']) : null;
      var price = map["price"];
      op.price =  price is int ? price.toDouble() : price is double ? price : null;
      op.status = map['status'] != null ? Status.values[map['status']] : null;
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
        var qty = map['quantity'];
        op.quantity = qty is int ? qty.toDouble() : qty is double ? qty : null;
        return op;
    } catch (e) {throw e;}
  }

  Store deserializeStoreMap(Map<String, dynamic> map){
    try {
      Store op = new Store();
      op.id = map['id'];
      op.name = map["name"];
      op.operators = [];
      if (map["operators"] != null && map["operators"] is List) map['operators'].forEach((op) => op.operators.add(deserializeOperatorMap(op)));
      op.partner = map["partner"] != null ? deserializePartnerMap(map["partner"]) : null;
      return op;
    } catch (e) {throw e;}
  }

    Partner deserializePartnerMap(Map<String, dynamic> map){
    try {
      Partner op = new Partner();
      op.id = map['id'];
      op.name = map["name"];
      op.products = [];
      if (map["products"] != null && map["products"] is List) map['products'].forEach((op) => op.products.add(deserializeProductMap(op)));
      op.active = map['active'];
      op.profiles = [];
      if (map["profiles"] != null && map["profiles"] is List) map['profiles'].forEach((op) => op.profiles.add(new Profile()));
      op.configurations = [];
      if (map["configurations"] != null && map["configurations"] is List) map['configurations'].forEach((op) => op.products.add(new Configuration()));
      op.operators = [];
      if (map["operators"] != null && map["operators"] is List) map['operators'].forEach((op) => op.products.add(deserializeOperatorMap(op)));

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

  Map<String, dynamic> serializePartner(Partner prod) {
    try {
      return {
        if (prod.id != null) "id": prod.id,
        if (prod.name != null) "name": prod.name,
        if (prod.stores != null) "stores": prod.stores.map((e) => serializeStore(e)),
        if (prod.products != null) "products": prod.products.map((e) => serializeProduct(e)),
        if (prod.active != null) "active": prod.active,
        // if (prod.profiles != null) "profiles": prod.profiles.map((e) => e.),
        // if (prod.configurations != null) "configurations": prod.configurations,
        // if (prod.operators != null) "unity": prod.operators.map((e) => serializeOperator(e))
      };
    } catch (e) {
      throw e;
    }
  }

    Map<String, dynamic> serializeStore(Store prod) {
    try {
      return {
        if (prod.id != null) "id": prod.id,
        if (prod.name != null) "name": prod.name,
        if (prod.partner != null) "partner": serializePartner(prod.partner),
        if (prod.orders != null) "orders": prod.orders.map((e) => serializeOrder(e)),
        if (prod.operators != null) "active": prod.operators.map((e) => serializeOperator(e)),
      };
    } catch (e) {
      throw e;
    }
  }