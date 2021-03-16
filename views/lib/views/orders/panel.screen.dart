import 'dart:convert';
import 'dart:io';
import 'package:comies/components/screen.comp.dart';
import 'package:comies/components/titlebox.comp.dart';
import 'package:comies/main.dart';
import 'package:comies/utils/converters.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class OrdersPanelScreen extends StatefulWidget {
  final channel = IOWebSocketChannel.connect(session.kitchenRoute, headers: {"authorization": session.token});
  @override
  OrdersPanel createState() => OrdersPanel();
}

class OrdersPanel extends State<OrdersPanelScreen> {
  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
  List<Order> orders = [];

  void setOrder(List<dynamic> ordersMap){
    ordersMap.map((e) => deserializeOrderMap(e)).toList().forEach((ord) {
      if (!orders.any((order) => order.id == ord.id)) orders.add(ord);
    });
  }

  IOWebSocketChannel ch;
  ScrollController ctr;
  String cod = "";
  var show = true;

  @override
  void initState(){
    ctr = new ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ch != null ? StreamBuilder(
        stream: ch.stream,
        builder: (context, datea){
          
          if (datea.hasData){
            if (show){cod = datea.data; show = false;}
            else ctr.jumpTo(double.tryParse(datea.data));
          }
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.pop(context),
              tooltip: 'Voltar',
              child: Icon(Icons.arrow_back),
              mini: true,
            ),

            appBar: AppBar(title: Text("Cozinha" + (cod == "" ? "" : " - ID: $cod"))),
            floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,


            body: StreamBuilder(
                  stream: widget.channel.stream,
                  builder: (context, data){

                    if (data.hasData){
                      setOrder(jsonDecode(data.data));
                      List<Order> pending = orders.where((ord) => ord.status == Status.pending).toList();
                      List<Order> preparing = orders.where((ord) => ord.status == Status.preparing).toList();
                      return Screen(
                        onRefresh: () => new Future(() => setState(() {})),
                        children: [
                          Row(
                            children: [
                              Expanded(flex: 35,
                                child: ListView(controller: ctr, children: [
                                  for (var order in pending) OrderCard(order: order)
                                ]),
                              ),
                              Expanded(flex: 65,
                                child: ListView(children: [
                                  for (var order in preparing) OrderCard(order: order)
                                ]),
                              )
                            ],
                          )
                        ]
                      );
                    } else return Center(child: Text("Ops! Nenhum pedido na cozinha."));
                  },
                )

          );
        },
      ) : Center(child:TextButton(child: Text("INICIAR"), onPressed: (){
        setState((){ch =  IOWebSocketChannel.connect(Uri.parse(session.screenTVRoute), headers: {"authorization": session.token});});
      }));
    
    
    
  }


  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}


class OrderCard extends StatefulWidget {
  final Order order;
  OrderCard({this.order});
  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 300,
        child: Column(
          children: [
            TitleBox("PEDIDO Nº "+widget.order.id.toString()),
            for (var it in widget.order.items) ListTile(title: Text("PRODUTO: ${it.product.name} - QUANTIDADE: ${it.quantity}")),
            Container(
              alignment: Alignment.bottomRight,
              child: Row(children: [TextButton(child: Text("PREPARAR"), onPressed: (){})]),
            )
        ])
      )
    );
  }
}