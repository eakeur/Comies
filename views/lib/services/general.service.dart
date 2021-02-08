import 'dart:convert';
import 'package:comies/main.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:comies/utils/declarations/environment.dart';
import 'package:http/http.dart' as service;

class GeneralService<T> {
  String _url;

  set path(String path) => _url = '${session.server}/$path';

  Map<String, String> headers = new Map<String, String>();

  GeneralService() {
    _url = session.server;
  }

  @flutter.protected
  void notify(Response response, dynamic context) {
    bool isBigScreen() => flutter.MediaQuery.of(context).size.width > widthDivisor;
    for (var not in response.notifications) {
      flutter.ScaffoldMessenger.of(context).showSnackBar(
        flutter.SnackBar(
          content: isBigScreen() ? flutter.Text(not.message, style: flutter.TextStyle(fontSize: 20)) : null,
          duration: Duration(seconds: 3),
          action: not.action != null
              ? flutter.SnackBarAction(
                  label: not.action.name,
                  onPressed: () =>
                      flutter.Navigator.pushNamed(context, not.action.href))
              : null,
        ),
      );
    }
  }

  @flutter.protected
  Future<Response> add(Map<String, dynamic> data) async {
    try {
      _setHeaders();
      String body = jsonEncode(data);

      service.Response response =
          await service.post(this._url, headers: this.headers, body: body);
      return _dealWithResponse(response);
    } catch (e) {
      print(e);
      return new Response(notifications: [
        Notification(message: "Opa! Um erro desconhecido occorreu.")
      ], success: false);
    }
  }

  @flutter.protected
  Future<Response> get({String query}) async {
    try {
      _setHeaders();
      service.Response  response = await service.get(
          this._url + "${query == null ? '' : query}",
          headers: this.headers);
      return _dealWithResponse(response);
    } catch (e) {
      print(e);
      return new Response(notifications: [
        Notification(message: "Opa! Um erro desconhecido occorreu.")
      ], success: false);
    }
  }

  @flutter.protected
  Future<Response> getOne(dynamic key) async {
    try {
      _setHeaders();
      service.Response  response =
          await service.get(this._url + '/$key', headers: this.headers);
      return _dealWithResponse(response);
    } catch (e) {
      print(e);
      return new Response(notifications: [
        Notification(message: "Opa! Um erro desconhecido occorreu.")
      ], success: false);
    }
  }

  @flutter.protected
  Future<Response> update(Map<String, dynamic> data) async {
    try {
      _setHeaders();
      String body = jsonEncode(data);
      service.Response  response =
          await service.put(this._url, headers: this.headers, body: body);
      return _dealWithResponse(response);
    } catch (e) {
      print(e);
      return new Response(notifications: [
        Notification(message: "Opa! Um erro desconhecido occorreu.")
      ], success: false);
    }
  }

  @flutter.protected
  Future<Response> delete(dynamic id) async {
    try {
      _setHeaders();
      service.Response  response =
          await service.delete('${this._url}/$id', headers: this.headers);
      return _dealWithResponse(response);
    } catch (e) {
      print(e);
      return new Response(notifications: [
        Notification(message: "Opa! Um erro desconhecido occorreu.")
      ], success: false);
    }
  }

  @flutter.protected
  Future<Response> getExternal(String externalURL) async {
    try {
      var resp = await service.get(externalURL);
      return new Response(success: true, data: resp.body);
    } catch (e) {
      print(e);
      return new Response(notifications: [
        Notification(message: "Opa! Um erro desconhecido occorreu.")
      ], success: false);
    }
  }

  @flutter.protected
  String getQueryString(Map<String, dynamic> map) {
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
      throw e;
    }
  }

  Response _dealWithResponse(service.Response responseParam) {
    try {
      print(_url);
      if (responseParam.statusCode == 401 || responseParam.statusCode == 403){
        return new Response(notifications: [
        Notification(message: "Opa! Você não tem acesso a esse recurso ou não está autenticado. Por favor, faça seu login novamente", action: {'name': 'Login', 'href': '/authentication'})
      ], success: false);
      }
      Map<dynamic, dynamic> rets = jsonDecode(responseParam.body);
      List<Notification> notifs = [];
      if (rets['notifications'] is List) {
        if (rets['notifications'].length > 0) {
          for (var not in rets['notifications']) {
            notifs.add(
                Notification(message: not['message'], action: not['action']));
          }
        }
      }
      Response response = new Response(
          data: rets["data"],
          access: rets["access"],
          notifications: notifs,
          success: rets['success']);

      if (response.access != null) session.token = response.access;
      return response;
    } catch (e) {
      return new Response(notifications: [
        Notification(message: "Opa! Um erro desconhecido occorreu.")
      ], success: false);
    }
  }

  void _setHeaders() {
    this.headers['Authorization'] = session.token;
    this.headers["Accept-Language"] = "pt-BR";
    this.headers["Content-Type"] = "application/json";
  }
}
