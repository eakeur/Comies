import 'package:comies/components/menu.comp.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:flutter/material.dart';

import 'edit.screen.dart';

class OrdersScreen extends StatefulWidget {
  @override
  Orders createState() => Orders();
}

class Orders extends State<OrdersScreen> {
  int id;

  bool hasID() => id != null;
  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: NavigationBar(),

        body: Center(child: Text("Clique em um pedido para ver os detalhes.")),

        floatingActionButton: AddButton(),
      );
  }
}

class AddButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) => new DetailedOrderScreen()));
        },
        tooltip: 'Adicionar pedido',
        child: Icon(Icons.add));
  }
}