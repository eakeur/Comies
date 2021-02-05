import 'package:comies/components/menu.comp.dart';
import 'package:comies/services/costumers.service.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/views/costumers/list.comp.dart';
import 'package:comies/views/orders/form.comp.dart';
import 'package:flutter/material.dart';

import 'edit.screen.dart';

class OrdersScreen extends StatefulWidget {
  @override
  Orders createState() => Orders();
}

class Orders extends State<OrdersScreen> {
  CostumersService service = new CostumersService();
  int id;

  bool hasID() => id != null;
  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: ComiesDrawer(),
        //The top bar app
        appBar: AppBar(title: Text('Pedidos'), elevation: 8, actions: [
          IconButton(icon: Icon(Icons.queue_play_next_outlined), onPressed: (){Navigator.pushNamed(context, '/panel');})
        ]),
        //The body of the app
        body: isBigScreen()
            ? Row(children: [
                Expanded(
                    flex: 35,
                    child: Card(
                        margin: EdgeInsets.all(0),
                        elevation: 8,
                        child: CostumersListComponent(
                            onListClick: (value) =>
                                setState(() => id = value)))),
                if (hasID())
                  Expanded(
                      flex: 65,
                      child: Center(
                          child: Container(
                              width: 600,
                              child: OrderFormComponent(
                                  id: id,
                                  afterDelete: () {setState(() { id = null;});},
                                  afterSave: () {setState(() {});}))))
                else
                  Expanded(
                      flex: 65,
                      child: Center(
                          child: Text(
                              "Clique em um pedido para ver os detalhes.")))
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
                        child: CostumersListComponent(
                            onListClick: (value){
                              setState((){
                                id = value;
                                 Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => new DetailedOrderScreen(id: id)));
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

  @override
  Widget build(BuildContext context) {
    bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
    return FloatingActionButton(
        onPressed: (){
          isBigScreen() ? 
            Scaffold.of(context).showBottomSheet((context) => 
              Container(height: MediaQuery.of(context).size.height - 100, child: DetailedOrderScreen()),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))
          : Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) => new DetailedOrderScreen()));
        },
        tooltip: 'Adicionar cliente',
        child: Icon(Icons.add));
  }
}