import 'package:comies/components/async.comp.dart';
import 'package:comies/services/costumers.service.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';

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
  TextEditingController searchController = new TextEditingController();
  CostumersService service = new CostumersService();
  List<Costumer> costumers = [];
  Costumer filter = new Costumer();
  LoadStatus status;

  void onSearchTap({setLoading = false}) {
    if (setLoading) setState(() => status = LoadStatus.loading);
    try{
      if (searchController.text.trim() == '') throw Exception();
      int.tryParse(searchController.text.substring(0, searchController.text.length > 4 ? 4 : searchController.text.length));
      service.getCostumersByPhone(searchController.text).then((value) => setState(() {
          costumers = value;
          status = LoadStatus.loaded;
        }));
    } catch(e){
      service.getCostumers(filter).then((value) => setState(() {
          costumers = value;
          status = LoadStatus.loaded;
        }));
    }
  }

  @override
  void didUpdateWidget(CostumersListComponent oldWidget){
    onSearchTap();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    onSearchTap(setLoading: true);
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
              helperText: "Pesquise por um nome ou telefone",
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
                        widget.onListClick(cost);
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.arrow_right),
                        onPressed: () => widget.onListClick(cost),
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