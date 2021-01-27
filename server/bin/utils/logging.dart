import 'dart:io';

void logRequest(HttpRequest request){
  print('${DateTime.now()} ${request.method}: ${request.uri.path}   ${request.response.statusCode}');
}