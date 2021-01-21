import 'package:comies/components/async.comp.dart';
import 'package:comies/services/products.service.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';

class ProductsListComponent extends StatefulWidget {
  final ProductsService service;
  final Function(int) onListClick;
  final Function(String) onSearchFieldChange;
  final LoadStatus status;
  final Function onSearchClick;

  ProductsListComponent({
    this.onSearchClick,
    this.onSearchFieldChange,
    this.onListClick,
    this.service,
    this.status,
    Key key,
  }) : super(key: key);

  @override
  ProductsList createState() => ProductsList();
}

class ProductsList extends State<ProductsListComponent> {
  TextEditingController searchController = new TextEditingController();
  LoadStatus status = LoadStatus.loaded;

  void addPropertyToSearchParams(String property) {
    widget.service.addProperty((prod) => prod.name = property);
  }

  @override
  Widget build(BuildContext context) {
    widget.service.setContext(context);
    return ListView(
      children: [
        SearchBar(
          searchController: searchController,
          onSearchTap: widget.onSearchClick,
          onFieldChanged: widget.onSearchFieldChange,
        ),
        AsyncComponent(
          data: widget.service.products,
          status: widget.status,
          messageIfNullOrEmpty:
              "Ops! Não encontramos nenhum produto! Tente especificar os filtros acima.",
          child: Container(
            child: ListComponent(
              onTap: widget.onListClick,
              onEditTap: widget.onListClick,
              list: widget.service.products,
            ),
          ),
        ),
      ],
    );
  }
}

class ListComponent extends StatelessWidget {
  final TextEditingController searchController;
  final Function(int) onTap;
  final Function(int) onEditTap;
  final Function(String) onFieldChanged;
  final Function() onSearchTap;
  final List<Product> list;

  ListComponent(
      {this.onTap,
      this.onEditTap,
      this.onFieldChanged,
      this.onSearchTap,
      this.searchController,
      this.list,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tiles = ListTile.divideTiles(
      context: context,
      tiles: [
        for (var prod in list)
          ListTile(
            title: Text("${prod.name}"),
            subtitle: Text("R\$${prod.price}"),
            onTap: () => onTap(prod.id),
            trailing: IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () => onEditTap(prod.id),
            ),
          ),
      ],
    ).toList();
    return Column(
      children: tiles,
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onFieldChanged;
  final Function() onSearchTap;

  SearchBar(
      {this.searchController, this.onFieldChanged, this.onSearchTap, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: TextFormField(
        controller: searchController,
        onChanged: onFieldChanged,
        onFieldSubmitted: (x) {
          onFieldChanged(x);
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
                    onFieldChanged("");
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
    );
  }
}
