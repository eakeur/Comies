import 'filter.dart';

class Query<T> {
  Set<Filter> filters = new Set<Filter>();

  String name = '';

  dynamic result;

  String targets = '';

  Query({String targets = "*"}) {
    this.targets = targets;
  }

  Future<String> get() async {
    String building = 'SELECT $targets FROM $name WHERE ';
    for (var i in filters) {
      building += "${i.filter} ";
    }

    return building;
  }

  Query where(String property, String verifier, dynamic value,
      {bool inclusive = false}) {
    try {
      filters.add(new Filter(
          property: property,
          verifier: verifier,
          value: value,
          inclusive: inclusive,
          addANDorOR: filters.isNotEmpty));
      return this;
    } catch (e) {
      throw e;
    }
  }
}
