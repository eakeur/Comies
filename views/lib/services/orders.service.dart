import 'package:comies/services/general.service.dart';
import 'package:comies_entities/comies_entities.dart';

class OrdersService extends GeneralService<Order> {
  dynamic _context;

  OrdersService() {
    this.path = 'orders';
  }

  void setContext(dynamic context) {
    this._context = context;
  }

  Future<List<Order>> getOrders(Order filter) async {
    Response res;
    try {
      List<Order> orders = [];
      res = await super
          .get(query: super.getQueryString(_serializeProduct(filter)));
      if (!(res.data is List)) {
        throw new Exception();
      } else {
        for (var item in res.data) {
          orders.add(_deserializeMap(item));
        }
      }
      return orders;
    } catch (e) {
      notify(res, _context);
      return [];
    }
  }

  Future<Order> getById(int id) async {
    Response res;
    try {
      res = await super.getOne(id);
      if (res.data == null) throw Exception;
      return _deserializeMap(res.data);
    } catch (e) {
      notify(res, _context);
      return new Order();
    }
  }

  Future<void> removeOrder(int id) async {
    Response res;
    try {
      res = await super.delete(id);
      notify(res, _context);
    } catch (e) {
      notify(res, _context);
    }
  }

  Future<void> addOrder(Order order) async {
    Response res;
    try {
      res = await super.add(_serializeProduct(order));
      notify(res, _context);
    } catch (e) {
      notify(res, _context);
    }
  }

  Future<void> updateOrder(Order order) async {
    Response res;
    try {
      res = await super.update(_serializeProduct(order));
      notify(res, _context);
    } catch (e) {
      notify(res, _context);
    }
  }

  Order _deserializeMap(dynamic map) {
    try {
      Order prod = new Order();
      if (map is Map && map != null) {
        prod.number = map['id'];
        prod.status = Status.values[map['status']];
        prod.placed = map['placed'];
        prod.active = map["active"];
        prod.price = map['price'];
      }
      return prod;
    } catch (e) {
      throw e;
    }
  }

  Map<String, dynamic> _serializeProduct(Order prod) {
    try {
      return {
        if (prod.number != null) "id": prod.number,
        if (prod.placed != null) "name": prod.placed,
        if (prod.status != null) "status": prod.status.index,
        if (prod.active != null) "active": prod.active,
        if (prod.price != null) "price": prod.price,
      };
    } catch (e) {
      throw e;
    }
  }
}
