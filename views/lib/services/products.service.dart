import 'package:comies/services/general.service.dart';
import 'package:comies_entities/comies_entities.dart';

class ProductsService extends GeneralService<Product> {
  dynamic _context;

  ProductsService() {
    this.path = 'products';
  }

  void setContext(dynamic context) {
    this._context = context;
  }

  Future<List<Product>> getProducts(Product filter) async {
    Response res;
    try {
      List<Product> prods = [];
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

  Future<Product> getById(int id) async {
    Response res;
    try {
      res = await super.getOne(id);
      if (res.data == null) throw Exception;
      return _deserializeMap(res.data);
    } catch (e) {
      notify(res, _context);
      return new Product();
    }
  }

  Future<void> removeProduct(int id) async {
    Response res;
    try {
      res = await super.delete(id);
      notify(res, _context);
    } catch (e) {
      notify(res, _context);
    }
  }

  Future<void> addProduct(Product product) async {
    Response res;
    try {
      res = await super.add(_serializeProduct(product));
      notify(res, _context);
    } catch (e) {
      notify(res, _context);
    }
  }

  Future<void> updateProduct(Product product) async {
    Response res;
    try {
      res = await super.update(_serializeProduct(product));
      notify(res, _context);
    } catch (e) {
      notify(res, _context);
    }
  }

  Product _deserializeMap(dynamic map) {
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

  Map<String, dynamic> _serializeProduct(Product prod) {
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

  Product createProduct() {
    return new Product();
  }
}
