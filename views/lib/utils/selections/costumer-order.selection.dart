import 'package:comies_entities/comies_entities.dart';

class CostumerOrderSelection{
  Costumer costumer;
  Address address;
  bool get hasCostumer => costumer != null && costumer.id != null && costumer.id != 0;
  bool get hasAddress => address != null && address.id != null && address.id != 0;
  bool get valid => costumer != null && costumer.id != null && costumer.id != 0 && address != null && address.id != null && address.id != 0;
}