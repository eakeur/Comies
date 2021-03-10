import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void notify(Response response, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: ListTile(title: Text(response.notification.message)),
          duration: Duration(seconds: 4),
          action: response.notification.action != null
              ? SnackBarAction(
                  label: response.notification.action.name,
                  onPressed: () => Navigator.pushNamed(context, response.notification.action.href))
              : null,
        ),
      );
}