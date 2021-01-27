import 'dart:io';
import 'package:args/args.dart';
import 'package:fluent_query_builder/fluent_query_builder.dart';
import 'controllers/products.controller.dart';
import 'utils/database.dart';
import 'utils/logging.dart';

void main(List<String> args) async {
  var parser = ArgParser()..addOption('port', abbr: 'p');
  var result = parser.parse(args);

  var portStr = result['port'] ?? Platform.environment['PORT'] ?? '8088';
  var port = int.tryParse(portStr);

  if (port == null) {
    stdout.writeln('Could not parse port value "$portStr" into a number.');
    exitCode = 64;
    return;
  }

  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  print('Serving at http://${server.address.host}:${server.port}');


  collection = await DbLayer().connect(DBConnectionInfo(
    host: 'localhost',
    database: 'comies',
    driver: ConnectionDriver.mysql,
    port: 3306,
    username: 'igor',
    password: '2001Database@))!',
    charset: 'utf8',
  ));


  await for (HttpRequest request in server) {
    if (request.uri.pathSegments.isNotEmpty){
      try {
          switch (request.uri.pathSegments[0]) {
          case 'products': ProductsController(request.uri.pathSegments, request); break;
          case 'costumers': break;
          case 'orders': break;
          case 'operators': break;
          case 'auth': break;
          default: request.response.statusCode = HttpStatus.notFound; break;
        }
      } catch (e) {
        request.response.statusCode = HttpStatus.internalServerError;
        request.response.write(e);
      }
    } else {
      request.response.statusCode = HttpStatus.notFound;
    }
    logRequest(request);
  }

  
}

