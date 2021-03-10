import 'package:comies_entities/comies_entities.dart';
import 'package:comies_entities/src/costumer.dart';

class Address {
  int id;
  String cep;
  String number;
  String district;
  String complement;
  String reference;
  String street;
  String city;
  String state;
  String country;
  Costumer costumer;
  List<Order> orders;
}
