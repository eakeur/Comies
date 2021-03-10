import 'dart:collection';
import 'package:comies/services/general.service.dart';
import 'package:comies/utils/converters.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/widgets.dart';

class OrderController extends ChangeNotifier {

  OrderController(){
    _order.items = [];
  }

  Order _order = new Order();
  Item _item;
  List<Order> _orders = [];

  Order get order => _order;
  Item get item => _item;
  Costumer get costumer => _order.costumer;
  Address get address => _order.address;


  UnmodifiableListView<Order> get orders => UnmodifiableListView(_orders);
  UnmodifiableListView<Item> get items => UnmodifiableListView(_order.items);
  UnmodifiableListView<int> get itemsGroups {
    List<int> gr = [];
    _order.items.forEach((item) {
      if (!gr.contains(item.group)) gr.add(item.group);
    });
    return UnmodifiableListView(gr);
  }


  Service<Order> service = new Service<Order>("orders", serializeOrder, deserializeOrderMap);




  bool get areItemsValid {
    return _order.items.isNotEmpty &&
    _order.items.every((item) => item.quantity > 0.0) &&
    _order.items.every((item) => item.product != null && item.product.id != null) &&
    _order.items.map((order) => order.group).map((group) =>
    _order.items.where((item) => item.group == group).fold<double>(0,
    (previousValue, item) => previousValue + item.quantity) >= 1)
    .toList().every((groupStatus) => groupStatus);
  }

  bool get isCostumerValid => costumer != null && address != null;

  bool get areDetailsValid => order.payment != null && order.deliverType != null;

  double get totalPrice => _order.items.fold(0.00, (previousValue, element) => previousValue + (element.quantity * element.product.price));



  String get paymentMethodText {
    switch (_order.payment) {
      case PaymentMethod.cash: return "Pagamento em dinheiro";
      case PaymentMethod.credit: return "Pagamento em crédito";
      case PaymentMethod.debit: return "Pagamento em débito";
      case PaymentMethod.transference: return "Pagamento por transferência";
      case PaymentMethod.pix: return "Pagamento por Pix";
      default: return "";
    }
  }

    String get deliverTypeText {
    switch (_order.deliverType) {
      case DeliverType.takeout: return "Pedido será retirado pelo cliente";
      case DeliverType.delivery: return "Pedido será entregue pelo restaurante";
      default: return "";
    }
  }


  Future<Response> addOrder(){
    _order.placed = DateTime.now();
    _order.price = totalPrice;
    return service.add(order);
  }





  void setItem(Product product){
    if (product != null){
      var existents = _order.items.where((item) => item.product.id == product.id).toList();
      if (existents.isNotEmpty){
        _item = _order.items[items.indexOf(existents[0])];
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
    _order.items.add(item);
    notifyListeners();
  }

  void removeItem(Item item) {
    _order.items.remove(item);
    notifyListeners();
  }

  void setCostumer(Costumer costumer){
    _order.costumer = costumer;
    notifyListeners();
  }
  
  void setAddress(Address address){
    _order.address = address;
    notifyListeners();
  }

  void setDeliverType(DeliverType type){
    _order.deliverType = type;
    notifyListeners();
  }

  void setPaymentMethod(PaymentMethod method){
    _order.payment = method;
    notifyListeners();
  }




}