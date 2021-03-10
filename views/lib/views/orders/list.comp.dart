import 'package:flutter/material.dart';

class OrdersListComponent extends StatefulWidget {
  final Function(int) onListClick;

  OrdersListComponent({
    this.onListClick,
    Key key,
  }) : super(key: key);

  @override
  OrdersList createState() => OrdersList();
}

class OrdersList extends State<OrdersListComponent> {

  @override  
  Widget build(BuildContext context) {
    return Text("Orders List");
  }
}