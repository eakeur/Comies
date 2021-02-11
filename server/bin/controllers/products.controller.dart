import 'dart:async';
import 'package:comies_entities/comies_entities.dart';
import 'package:jaguar/jaguar.dart';


@GenController(path: '/products')
class ProductsController extends Controller {

  @Get()
  Future<String> getProducts(Context context) async {
    return 'Hello';

  }

}