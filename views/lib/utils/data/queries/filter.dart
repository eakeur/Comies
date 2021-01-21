import 'dart:ffi';

import 'query.dart';

class Filter {
  String filter = '';
  Filter(
      {String property = '',
      String verifier = '=',
      dynamic value,
      bool inclusive = false,
      bool addANDorOR = false}) {
    if (value is DateTime) {
      filter =
          "${_addConector(addANDorOR, inclusive)}$property $verifier '${value.toString()}'";
    }
    if (value is String) {
      filter =
          "${_addConector(addANDorOR, inclusive)}$property $verifier '$value'";
    }
    if (value is int || value is Float || value is Double) {
      filter =
          "${_addConector(addANDorOR, inclusive)}$property $verifier $value";
    }
    if (value is Query) {
      String building = 'SELECT ${value.targets} FROM ${value.name} WHERE ';
      for (var i in value.filters) {
        building += "${i.filter} ";
      }
      filter =
          "${_addConector(addANDorOR, inclusive)}$property $verifier $building";
    }
  }

  String _addConector(bool add, bool what) {
    if (add) {
      if (what) {
        return 'OR ';
      } else {
        return 'AND ';
      }
    } else {
      return '';
    }
  }
}
