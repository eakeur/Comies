


import 'dart:io';

import 'package:args/args.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

import 'controllers/products.controller.dart';

void main(List<String> args) async {
  var parser = ArgParser()..addOption('port', abbr: 'p');
  var result = parser.parse(args);
  // var port = int.parse(result['port']) ?? int.parse(Platform.environment['PORT']) ?? 8080;
  final server = Jaguar(port: 8080);
  server.add(reflect(ProductsController()));
  await server.serve();
  // collection = await DbLayer().connect(DBConnectionInfo(
  //   host: 'localhost',
  //   database: 'comies',
  //   driver: ConnectionDriver.mysql,
  //   port: 3306,
  //   username: 'igor',
  //   password: '2001Database@))!',
  //   charset: 'utf8',
  // ));


  
}

