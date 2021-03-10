import 'package:comies/components/async.comp.dart';
import 'package:comies/components/responsebar.comp.dart';
import 'package:comies/components/textfield.comp.dart';
import 'package:comies/controllers/costumer.controller.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CostumersListComponent extends StatefulWidget {
  final Function(Costumer) onListClick;

  CostumersListComponent({
    this.onListClick,
    Key key,
  }) : super(key: key);

  @override
  CostumersList createState() => CostumersList();
}

class CostumersList extends State<CostumersListComponent> {
  bool searchByPhone = false;

  void onSearchTap() {
    searchByPhone
      ? Provider.of<CostumerController>(context, listen: false).getCostumersByPhone()
      .catchError((value){ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value));})
      : Provider.of<CostumerController>(context, listen: false).getCostumers()
      .catchError((value){ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value));});
  }



  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SearchBarComponent(
          onSearchTap: onSearchTap,
          filters: [SearchFilter(null, "Pesquisar", (s) {
            searchByPhone = int.tryParse(s)!=null ? true : false;
            searchByPhone 
              ? Provider.of<CostumerController>(context, listen: false).phoneQuery.number = s
              : Provider.of<CostumerController>(context, listen: false).costumerQuery.name = s;
          })],
        ),
        Consumer<CostumerController>(
          builder: (context, data, child){
            return AsyncComponent(
              initialMessage: "Pesquise o nome ou o número de telefone de um cliente para achá-lo.",
              data: data.costumers,
              status: data.costumersLoadStatus,
              messageIfNullOrEmpty: "Ops! Não encontramos nenhum cliente! Tente especificar os filtros acima.",
              child: Container(
                child: Column(
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: [
                      for (var cost in data.costumers)
                        ListTile(
                          title: Text("${cost.name}"),
                          onTap: (){
                            data.setCostumer(cost); 
                            if (widget.onListClick != null)widget.onListClick(cost);
                          },
                          trailing: IconButton(
                            icon: Icon(Icons.arrow_right),
                            onPressed: (){
                              data.setCostumer(cost); 
                              if (widget.onListClick != null)widget.onListClick(cost);
                            },
                          ),
                        ),
                    ],
                  ).toList(),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}