import 'package:flutter/material.dart';
import 'package:comies_entities/comies_entities.dart' as ent;

// ignore: non_constant_identifier_names
SnackBar ResponseBar(ent.Response res, {Function action}) => SnackBar(
  backgroundColor: res.success ? Colors.green[700] : Colors.red[700],
  content: res.notification != null ? ListTile(
    title: Text(res.notification.message, style: TextStyle(color: Colors.white))
  ) : ListTile(title: Text("Sucesso!", style: TextStyle(color: Colors.white))),
  action: action != null ? SnackBarAction(label: "TENTAR DE NOVO", onPressed: action, textColor: Colors.white) : null,
  duration: Duration(seconds: 5)
);