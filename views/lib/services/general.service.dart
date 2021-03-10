import 'dart:convert';
import 'package:comies/main.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:http/http.dart' show get, put, post, delete;


class Service<T> {
  String _url;

  set path(String path) => _url = '${session.server}/$path';

  Map<String, String> _headers = new Map<String, String>();

  Map<String, dynamic> Function(T) serializer;
  T Function(Map<String, dynamic>) deserializer;

  Service(String endpoint, this.serializer, this.deserializer) {
    path = endpoint;
  }

  Future<Response<void>> add(T object) async {
    try {
      _setHeaders();
      String body = jsonEncode(serializer(object));
      var response = await post(_url, headers: _headers, body: body);
      return _dealWithResponse<void>(response);
    } catch (e) {
      if (e is Response) throw e;
      throw  _getErrorResponse(null);
    }
  }

  Future<Response<void>> addMany(List<T> object) async {
    try {
      _setHeaders();
      String body = jsonEncode(object.map((obj) => serializer(obj)).toList());
      var response = await post(_url, headers: _headers, body: body);
      return _dealWithResponse<void>(response);
    } catch (e) {
      if (e is Response) throw e;
      throw  _getErrorResponse(null);
    }
  }

  Future<Response<void>> remove(int id) async {
    try {
      _setHeaders();
      var response = await delete('$_url/$id', headers: _headers);
      return _dealWithResponse<void>(response);
    } catch (e) {
      if (e is Response) throw e;
      throw  _getErrorResponse(null);
    }
  }

  Future<Response<void>> removeMany(List<int> ids) async {
    try {
      _setHeaders();
      var response = await post('$_url', headers: _headers, body: jsonEncode(ids));
      return _dealWithResponse<void>(response);
    } catch (e) {
      if (e is Response) throw e;
      throw  _getErrorResponse(null);
    }
  }

  Future<Response<T>> getOne(int id) async {
    try {
      _setHeaders();
      var response = await get(_url + '/$id', headers: _headers);
      return _dealWithResponse<T>(response);
    } catch (e) {
      if (e is Response) throw e;
      throw  _getErrorResponse(null);
    }
  }

  Future<Response<List<T>>> getMany({Map<String, dynamic> query, T filter}) async {
    try {
      _setHeaders();
      String params = filter != null ? _getQueryString(serializer(filter)) : _getQueryString(query) ?? '';
      var response = await get(_url + "$params", headers: _headers);
      return _dealWithResponse<List<T>>(response);
    } catch (e) {
      if (e is Response) throw e;
      throw  _getErrorResponse(null);
    }
  }

  Future<Response<void>> update(T object) async {
    try {
      _setHeaders();
      String body = jsonEncode(serializer(object));
      var response = await put(_url, headers: _headers, body: body);
      return _dealWithResponse<void>(response);
    } catch (e) {
      if (e is Response) throw e;
      throw  _getErrorResponse(null);
    }
  }

  Future<Response<void>> updateMany(List<T> object) async {
    try {
      _setHeaders();
      String body = jsonEncode(object.map((obj) => serializer(obj)).toList());
      var response = await put(_url, headers: _headers, body: body);
      return _dealWithResponse<void>(response);
    } catch (e) {
      if (e is Response) throw e;
      throw  _getErrorResponse(null);
    }
  }
  
  void _setHeaders(){
    _headers['Authorization'] = session.token;
    _headers["Accept-Language"] = "pt-BR";
    _headers["Content-Type"] = "application/json";
  }

  String _getQueryString(Map<String, dynamic> map) {
    try {
      String query = "";
      map.keys.forEach((key) {
        if (map[key] != null) {
          query == ""
              ? query = '?$key=${map[key]}'
              : query += '&$key=${map[key]}';
        }
      });
      return query;
    } catch (e) {
      return null;
    }
  }

  Response<K> _dealWithResponse<K>(dynamic raw){
    try {
      print(_url);
      if (raw.statusCode == 401 || raw.statusCode == 403){
        return new Response<K>(notification: 
          Notification(message: "Hmm! Você não tem acesso a esse recurso ou não está autenticado. Por favor, faça seu login novamente", action: {'name': 'Login', 'href': '/authentication'}), success: false);
      }
      Map<dynamic, dynamic> rets = jsonDecode(raw.body);

      Notification notif;
      var notifdata = rets["notification"];
      if (notifdata != null) notif = new Notification(message: rets["notification"]["message"], action: rets["notification"]["action"]);
      dynamic data;
      var returnData = rets['data'];
      if (returnData != null){
        if (returnData is List){
          data = returnData.map((e) => deserializer(e)).toList();
        } else {
          data = deserializer(returnData);
        }
      }

      Response<K> response = new Response<K>(
          data: data,
          access: rets["access"],
          notification: notif,
          success: rets['success']);

      if (response.access != null) session.token = response.access;
      return response;
    } catch (e) {
      return new Response<K>(notification: 
        Notification(message: "Eita! Um erro desconhecido occorreu.")
      , success: false);
    }
  }

  Response<K> _getErrorResponse<K>(int statusCode){
    switch (statusCode) {
      case 0: return new Response<K>(notification: Notification(message: "Opa! Um erro desconhecido occorreu."), success: false);
      case 401: return new Response<K>(notification: Notification(message: "Hmm! Você não tem acesso a esse recurso ou não está autenticado. Por favor, faça seu login novamente", action: {'name': 'Login', 'href': '/authentication'}), success: false);
      case 403: return new Response<K>(notification: Notification(message: "Hmm! Você não tem acesso a esse recurso ou não está autenticado. Por favor, faça seu login novamente", action: {'name': 'Login', 'href': '/authentication'}), success: false);
      default: return new Response<K>(notification: Notification(message: "Opa! Um erro desconhecido occorreu."), success: false);
    }
  }

  static Future<Response<dynamic>> getExternalResource(String url) async {
    try {
      var resp = await get(url);
      print(url);
      return new Response(success: true, data: jsonDecode(resp.body));
    } catch (e) {
      return new Response(notification:
        Notification(message: "Opa! Um erro desconhecido occorreu.")
      , success: false);
    }
  }

}
