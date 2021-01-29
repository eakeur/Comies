import 'package:comies/services/products.service.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/utils/declarations/menu.dart';
import 'package:comies/views/products/edit.screen.dart';
import 'package:comies/views/products/form.comp.dart';
import 'package:comies/views/products/list.comp.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  final MenuEntries menu;
  ProductsScreen({Key key, this.menu}) : super(key: key);

  @override
  Products createState() => Products();
}

class Products extends State<ProductsScreen> {
  ProductsService service = new ProductsService();
  int id;

  bool hasID() => id != null;
  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: widget.menu.drawer(context),
        //The top bar app
        appBar: AppBar(title: Text('Produtos'), elevation: 8),
        //The body of the app
        body: isBigScreen()
            ? Row(children: [
                Expanded(
                    flex: 35,
                    child: Card(
                        margin: EdgeInsets.all(0),
                        elevation: 8,
                        child: ProductsListComponent(
                            onListClick: (value) =>
                                setState(() => id = value)))),
                if (hasID())
                  Expanded(
                      flex: 65,
                      child: Center(
                          child: Container(
                              width: 600,
                              child: ProductFormComponent(
                                  id: id,
                                  afterDelete: () {setState(() { id = null;});},
                                  afterSave: () {setState(() {});}))))
                else
                  Expanded(
                      flex: 65,
                      child: Center(
                          child: Text(
                              "Clique em um produto para ver os detalhes.")))
              ])
            : RefreshIndicator(
                child: GridView.count(
                    padding: EdgeInsets.all(16),
                    crossAxisCount: 1,
                    children: [
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        child: ProductsListComponent(
                            onListClick: (value){
                              setState((){
                                id = value;
                                 Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => new DetailedScreen(id: id)));
                              });
                            }),
                      )
                    ]),
                onRefresh: () => new Future(() => setState(() {})),
              ),
        // The FAB button at the bottom of the screen
        floatingActionButton: AddButton());
  }
}

class AddButton extends StatelessWidget {


  void buttonAction(){
    
  }
  
  @override
  Widget build(BuildContext context) {
    bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
    return FloatingActionButton(
        onPressed: (){
          isBigScreen() ? 
            Scaffold.of(context).showBottomSheet((context) => 
              Container(height: MediaQuery.of(context).size.height - 100, child: DetailedScreen()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))
          : Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) => new DetailedScreen()));
        },
        tooltip: 'Adicionar produto',
        child: Icon(Icons.add));
  }
}
