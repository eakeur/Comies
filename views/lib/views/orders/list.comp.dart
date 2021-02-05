import 'package:comies/components/async.comp.dart';
import 'package:comies/services/costumers.service.dart';
import 'package:comies_entities/comies_entities.dart';
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
  TextEditingController searchController = new TextEditingController();
  CostumersService service = new CostumersService();
  List<Costumer> costumers = [];
  Costumer filter = new Costumer();
  LoadStatus status;

  void onSearchTap() {
    setState(() {
      status = LoadStatus.loading;
    });
    service.getCostumers(filter).then((value) => setState(() {
          costumers = value;
          status = LoadStatus.loaded;
        }));
  }

  @override
  void didUpdateWidget(OrdersListComponent oldWidget){
    onSearchTap();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    onSearchTap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    service.setContext(context);
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          child: TextFormField(
            controller: searchController,
            onChanged: (change) => filter.name = change,
            onFieldSubmitted: (change) {
              filter.name = change;
              onSearchTap();
            },
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: "Pesquisar",
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (searchController.text != "")
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        searchController.text = "";
                        filter.name = "";
                        onSearchTap();
                      },
                    ),
                  IconButton(
                    icon: Icon(Icons.filter_alt),
                    onPressed: null,
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: onSearchTap,
                  ),
                ],
              ),
            ),
          ),
        ),
        AsyncComponent(
          data: costumers,
          status: status,
          messageIfNullOrEmpty:
              "Ops! Não encontramos nenhum cliente! Tente especificar os filtros acima.",
          child: Container(
            child: Column(
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  for (var cost in costumers)
                    ListTile(
                      title: Text("${cost.name}"),
                      onTap: (){
                        widget.onListClick(cost.id);
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.arrow_right),
                        onPressed: () => widget.onListClick(cost.id),
                      ),
                    ),
                ],
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }
}