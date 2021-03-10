import 'package:comies/main.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/views/orders/form.comp.dart';
import 'package:flutter/material.dart';

class DetailedOrderScreen extends StatefulWidget {
  final int id;

  DetailedOrderScreen({this.id});

  @override
  Order createState() => Order();
}

class Order extends State<DetailedOrderScreen> {

  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
  bool hasID() => widget.id != null && widget.id != 0;

  
  @override
  Widget build(BuildContext context) {
    return session.isAuthenticated ? Scaffold(
            //The top bar app
            appBar: AppBar(
              title: Text(hasID() ? 'Detalhes' : 'Adicionar'),
              elevation: 8
            ),
            //The body of the app
            body: OrderFormComponent(id:widget.id, afterDelete:(){Navigator.pop(context);}, afterSave: (){Navigator.pop(context);})
          ) : session.goToAuthenticationScreen();
  }
}

