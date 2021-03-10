import 'package:comies/controllers/product.controller.dart';
import 'package:comies/main.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/views/products/form.comp.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailedProductScreen extends StatefulWidget {
  final Product product;
  final bool isAddition;

  DetailedProductScreen({this.product, this.isAddition = false});

  @override
  Detailed createState() => Detailed();
}

class Detailed extends State<DetailedProductScreen> {

  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
  bool hasID() => widget.product != null && widget.product.id != null && widget.product.id != 0;

  
  @override
  Widget build(BuildContext context) {
    return session.isAuthenticated
      ?  ChangeNotifierProvider(
        create: (context) => ProductsController(product: widget.product),
        child: Scaffold(
          appBar: AppBar(
            title: Text(!widget.isAddition ? 'Detalhes' : 'Adicionar'),
            elevation: 8
          ),
          body: ProductFormComponent(isAddition:widget.isAddition, afterDelete:(){Navigator.pop(context);}, afterSave: (){Navigator.pop(context);})
        ),
      )
      : session.goToAuthenticationScreen();
  }
}

