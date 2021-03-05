import 'package:flutter/material.dart';
import 'package:comies_entities/comies_entities.dart' as ent;

// ignore: non_constant_identifier_names
SnackBar ResponseBar(ent.Notification not) => SnackBar(
  content: ListTile(title: Text(not.message)),
  duration: Duration(seconds: 4)
);