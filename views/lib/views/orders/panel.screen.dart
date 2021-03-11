import 'package:comies/main.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class OrdersPanelScreen extends StatefulWidget {
  final channel = IOWebSocketChannel.connect('ws://localhost:8080/kitchen/1/1/'+session.token);
  @override
  OrdersPanel createState() => OrdersPanel();
}

class OrdersPanel extends State<OrdersPanelScreen> {
  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        tooltip: 'Voltar',
        child: Icon(Icons.arrow_back),
        mini: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: StreamBuilder(
        stream: widget.channel.stream,
        builder: (context, data){
          return data.hasData ? Text(data.data) : Text("Nenhum pedido por aqui");
        },
      )

    );
  }
}

class AdaptableWidget extends StatelessWidget {
  final List<Widget> children;
  AdaptableWidget({this.children});

  @override
  Widget build(BuildContext context) {
    bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
    return isBigScreen()
        ? Row(
            children: [
              if (children.length >= 0) Expanded(flex: 25, child: children[0]),
              if (children.length > 1) Expanded(flex: 25, child: children[1]),
              if (children.length > 2) Expanded(flex: 25, child: children[2]),
              if (children.length > 3) Expanded(flex: 25, child: children[3]),
            ],
          )
        : Column(
            children: children,
          );
  }
}

class NewOrdersColumn extends StatelessWidget {
  final List<Order> orders;
  NewOrdersColumn({this.orders});
  bool hasOrders() => orders.isNotEmpty;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 15),
      child: !hasOrders()
          ? Center(child: Text('Nenhum pedido nesta etapa!'))
          : ListView(
              children: [
                for (var order in orders)
                  GeneralOrderCard(order: order)
              ],
            ),
    );
  }
}

class GeneralOrderCard extends StatelessWidget {
  final Order order;
  GeneralOrderCard({this.order});
  @override
  Widget build(BuildContext context) {
    order.status = Status.waiting;
    Color statusColor;
    switch (order.status) {
      case Status.confirmed: statusColor = Colors.deepOrange; break;
      case Status.preparing: statusColor = Colors.orange; break;
      case Status.waiting: statusColor = Colors.green; break;
      default: statusColor = Colors.deepOrange; break;
    }
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: statusColor, width: 3),
        borderRadius: BorderRadius.all(Radius.circular(4))
      ),
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 250,
        ),
      ),
    );
  }
}
