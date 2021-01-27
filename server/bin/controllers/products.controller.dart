import 'dart:convert';
import 'dart:io';

import '../services/products.service.dart';

class ProductsController {

  List<String> route;
  HttpRequest request;

  ProductsController(List<String> route, this.request){
    switch (request.method) {
      case 'GET': view(); break;
      case 'PUT': post(); break;
      case 'POST': delete(); break;
      case 'DELETE': put(); break;
      default: request.response.statusCode = HttpStatus.notImplemented; break;
    }
  }

  void view() {
    ProductsService().view(request.uri.queryParameters)
    .then((value){
      request.response.write(jsonEncode(value));
      request.response.close();
    });
    
  }

  void post(){

  }

  void delete(){

  }

  void put(){

  }
}