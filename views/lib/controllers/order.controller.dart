import 'dart:collection';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/widgets.dart';



class CostumerOrderSelectionController extends ChangeNotifier {

  Costumer _costumer;
  Address _address;

  Address get address => _address;
  Costumer get costumer => _costumer;
  bool get hasCostumer => _costumer != null && _costumer.id != null && _costumer.id != 0;
  bool get hasAddress => _address != null && _address.id != null && _address.id != 0;
  bool get valid => _costumer != null && _costumer.id != null && _costumer.id != 0 && _address != null && _address.id != null && _address.id != 0;

  void setCostumer(Costumer costumer){
    _costumer = costumer;
    notifyListeners();
  }
  
  void setAddress(Address address){
    _address = address;
  }

}

class OrderItemsSelectionController extends ChangeNotifier {

  final List<Item> _items = [];
  Item _item;
  Item get item => _item;
  bool get areItemsValid {
    return _items.isNotEmpty &&
    _items.every((item) => item.quantity > 0.0) &&
    _items.every((item) => item.product != null && item.product.id != null) &&
    _items.map((order) => order.group).map((group) =>
    _items.where((item) => item.group == group).fold<double>(0,
    (previousValue, item) => previousValue + item.quantity) >= 1)
    .toList().every((groupStatus) => groupStatus);
  }
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);
  UnmodifiableListView<int> get itemsGroups {
    List<int> gr = [];
    _items.forEach((item) {
      if (!gr.contains(item.group)) gr.add(item.group);
    });
    return UnmodifiableListView(gr);
  }

  void setItem(Product product){
    if (product != null){
      var existents = items.where((item) => item.product.id == product.id).toList();
      if (existents.isNotEmpty){
        _item = items[items.indexOf(existents[0])];
      } else {
        _item = new Item(); _item.quantity = product.min;
        _item.group = 1; _item.product = product;
      }
    } else {
      _item = null;
    }
    notifyListeners();
  }

  void setItemQuantity(double quantity){
    _item.quantity = quantity;
    notifyListeners();
  }

  void addItem(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(Item item) {
    _items.remove(item);
    notifyListeners();
  }

  void removeAllItems() {
    _items.clear();
    notifyListeners();
  }


}