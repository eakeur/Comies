import 'package:comies/components/async.comp.dart';
import 'package:comies/services/products.service.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';

class ProductsListComponent extends StatefulWidget {
  final Function(Product) onListClick;
  final Widget underList;

  ProductsListComponent({
    this.onListClick,
    this.underList,
    Key key,
  }) : super(key: key);

  @override
  ProductsList createState() => ProductsList();
}

class ProductsList extends State<ProductsListComponent> {
  TextEditingController searchController = new TextEditingController();
  ProductsService service = new ProductsService();
  int clicked = 0;
  List<Product> products = [];
  Product filter = new Product();
  LoadStatus status;

  void onSearchTap({setLoading = false}) {
    if (setLoading) setState(() => status = LoadStatus.loading);
    service.getProducts(filter).then((value) => setState(() {
          products = value;
          status = LoadStatus.loaded;
        }));
  }

  @override
  void didUpdateWidget(ProductsListComponent oldWidget){
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
          data: products,
          status: status,
          messageIfNullOrEmpty:
              "Ops! Não encontramos nenhum produto! Tente especificar os filtros acima.",
          child: Container(
            child: Column(
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  for (var prod in products)
                    ListTile(
                      title:  widget.underList != null && clicked == prod.id ? Text("${prod.name}", style: TextStyle(fontSize: 20)) : Text("${prod.name}"),
                      subtitle: widget.underList != null && clicked == prod.id ? Container(
                        padding: EdgeInsets.all(10),
                        child: widget.underList,
                        ) : Text("R\$${prod.price}"),
                      onTap: (){
                        clicked = clicked == prod.id ? clicked = 0 : clicked = prod.id;
                        widget.onListClick(prod);
                      },
                      trailing: widget.underList != null && clicked == prod.id ? null : IconButton(
                        icon: Icon(Icons.arrow_right),
                        onPressed: (){clicked = clicked == prod.id ? clicked = 0 : clicked = prod.id; widget.onListClick(prod);},
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