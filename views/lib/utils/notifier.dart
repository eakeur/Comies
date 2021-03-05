import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void notify(Response response, BuildContext context) {
    for (var not in response.notifications) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: ListTile(title: Text(not.message)),
          duration: Duration(seconds: 4),
          action: not.action != null
              ? SnackBarAction(
                  label: not.action.name,
                  onPressed: () => Navigator.pushNamed(context, not.action.href))
              : null,
        ),
      );
    }
}