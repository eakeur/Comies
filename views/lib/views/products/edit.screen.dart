import 'package:comies/main.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/views/products/form.comp.dart';
import 'package:flutter/material.dart';

class DetailedProductScreen extends StatefulWidget {
  final int id;

  DetailedProductScreen({this.id});

  @override
  Detailed createState() => Detailed();
}

class Detailed extends State<DetailedProductScreen> {

  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
  bool hasID() => widget.id != null && widget.id != 0;

  
  @override
  Widget build(BuildContext context) {
    return session.isAuthenticated() ? Scaffold(
            //The top bar app
            appBar: AppBar(
              title: Text(hasID() ? 'Detalhes' : 'Adicionar'),
              elevation: 8
            ),

            //The body of the app
            body: ProductFormComponent(id:widget.id, afterDelete:(){Navigator.pop(context);}, afterSave: (){Navigator.pop(context);})
          ) : session.goToAuthenticationScreen();
  }
}

