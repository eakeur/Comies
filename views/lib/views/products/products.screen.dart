import 'package:comies/components/menu.comp.dart';
import 'package:comies/controllers/product.controller.dart';
import 'package:comies/main.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/views/products/edit.screen.dart';
import 'package:comies/views/products/form.comp.dart';
import 'package:comies/views/products/list.comp.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  @override
  Products createState() => Products();
}

class Products extends State<ProductsScreen> {
  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;

  void navigateTo(Product product) => Navigator.push(context,
    MaterialPageRoute(builder: (BuildContext context) => DetailedProductScreen(product: product)));


  @override
  Widget build(BuildContext context) {
    return session.isAuthenticated 
      ?  ChangeNotifierProvider(
        create: (context) => ProductsController(),
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

          bottomNavigationBar: NavigationBar(),

          body: isBigScreen()
              ? Row(children: [
                  Expanded(flex: 35,
                    child: Card(
                        margin: EdgeInsets.all(0),
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                        child: ProductsListComponent())
                  ),
                  Expanded(flex: 65, child: Center(child: Container(child: ProductFormComponent())))
                ])
              : Container(
                child: ProductsListComponent(onListClick: (product) => navigateTo(product))
              ),

          floatingActionButton: session.permissions.canAddProducts ? AddButton() : null 
          
        ),
      )
      : session.goToAuthenticationScreen();
  }
}
class AddButton extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
    return FloatingActionButton(
      isExtended: true,
        onPressed: (){
          isBigScreen() ? 
            Scaffold.of(context).showBottomSheet((context) => 
              Container(height: MediaQuery.of(context).size.height - 100, child: DetailedProductScreen(product: new Product(), isAddition: true)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))
          : Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) => new DetailedProductScreen(product: new Product(), isAddition: true)));
        },
        tooltip: 'Adicionar produto',
        child: Icon(Icons.add));
  }
}
