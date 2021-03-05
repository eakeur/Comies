import 'dart:collection';
import 'package:comies/services/products.service.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductsController extends ChangeNotifier {

  Product _product;
  Product query = new Product();
  List<Product> _products = [];
  SnackBar snackbar;
  LoadStatus productsLoadStatus = LoadStatus.loaded; 
  LoadStatus productLoadStatus = LoadStatus.loaded;
  bool updatePending = false;
  bool deletePending = false;
  bool addPending = false;
  Product get product => _product;
  UnmodifiableListView<Product> get products => UnmodifiableListView<Product>(_products);
  ProductsService service = new ProductsService();

  ProductsController({Product product, List<Product> products, Product query}){
    if (product != null) _product = product;
    if (products != null) _products = products;
    if (query != null) this.query = query;
    getProducts();
  }



  Future<Response> getProducts() async {
    _products = [];
    productsLoadStatus = LoadStatus.loading;
    notifyListeners();
    try {
      var res = await service.getProducts(query);
      if (!res.success) throw res;
      productsLoadStatus = LoadStatus.loaded;
      _products = res.data;
      return res;
    } catch (e) {
      productsLoadStatus = LoadStatus.failed;
      throw e;
    } finally {
      notifyListeners();
    }
  }

  void setProduct(Product product){
    _product = product;
    productLoadStatus = LoadStatus.loaded;
    notifyListeners();
  }

  Future<Response> addProduct() async {
    productLoadStatus = LoadStatus.loading;
    addPending = true;
    notifyListeners();
    try {
      var res = await service.addProduct(product);
      productLoadStatus = LoadStatus.loaded;
      if (!res.success) throw res;
      return res;
    } catch (e) {
      productLoadStatus = LoadStatus.failed;
      throw e;
    } finally {
      addPending = false;
      notifyListeners();
    }
  }

  Future<Response> removeProduct() async {
    productLoadStatus = LoadStatus.loading;
    deletePending = true;
    notifyListeners();
    try {
      _products.remove(_product);
      var res = await service.removeProduct(product.id);
      productLoadStatus = LoadStatus.loaded;
      if (!res.success) throw res;
      _product = null;
      return res;
    } catch (e) {
      productLoadStatus = LoadStatus.failed;
      throw e;
    } finally {
      deletePending = false;
      notifyListeners();
    }
  }

  Future<Response> updateProduct() async {
    productLoadStatus = LoadStatus.loading;
    updatePending = true;
    notifyListeners();
    try {
      var res = await service.updateProduct(product);
      productLoadStatus = LoadStatus.loaded;
      if (!res.success) throw res;
      return res;
    } catch (e) {
      productLoadStatus = LoadStatus.failed;
      throw e;
    } finally {
      updatePending = false;
      notifyListeners();
    }
  }
  

}