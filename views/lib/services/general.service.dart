import 'dart:convert';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:comies/utils/declarations/environment.dart';
import 'package:http/http.dart' as service;

class GeneralService<T> {
  String _url;

  set path(String path) => _url = '$URL/$path';

  Map<String, String> headers = new Map<String, String>();

  GeneralService() {
    _url = URL;
  }

  @flutter.protected
  void notify(Response response, dynamic context) {
    for (var not in response.notifications) {
      flutter.Scaffold.of(context).showSnackBar(
        flutter.SnackBar(
          content: flutter.Text(not.message),
          duration: Duration(seconds: 2),
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

      dynamic response =
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
      dynamic response = await service.get(
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
      dynamic response =
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
      dynamic response =
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
      dynamic response =
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
  Future<dynamic> getExternal(String externalURL) async {
    try {
      return await service.get(externalURL);
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

  Response _dealWithResponse(dynamic responseParam) {
    try {
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

      if (rets["access"] != null) access = rets["access"];
      return response;
    } catch (e) {
      return new Response(notifications: [
        Notification(message: "Opa! Um erro desconhecido occorreu.")
      ], success: false);
    }
  }

  void _setHeaders() {
    this.headers['Authorization'] = access;
    this.headers["Accept-Language"] = "pt-BR";
    this.headers["Content-Type"] = "application/json";
  }
}
