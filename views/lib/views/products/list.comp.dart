import 'package:comies/components/async.comp.dart';
import 'package:comies/components/responsebar.comp.dart';
import 'package:comies/components/textfield.comp.dart';
import 'package:comies/controllers/product.controller.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsListComponent extends StatefulWidget {
  final Function(Product) onListClick;

  ProductsListComponent({this.onListClick, Key key}) : super(key: key);

  @override
  ProductsList createState() => ProductsList();
}

class ProductsList extends State<ProductsListComponent> {
  void onSearchTap() => Provider.of<ProductsController>(context, listen: false).getProducts()
    .catchError((value){ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value.notifications[0]));});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SearchBarComponent(
          onSearchTap: onSearchTap,
          filters: [SearchFilter(null, "Pesquisar", (s) => Provider.of<ProductsController>(context, listen: false).query.name = s)],
        ),
        Consumer<ProductsController>(builder: (context, data, child) {
          return AsyncComponent(
            data: data.products,
            status: data.productsLoadStatus,
            messageIfNullOrEmpty:
                "Ops! Não encontramos nenhum produto! Tente especificar os filtros acima.",
            child: Container(
              child: Column(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: [
                    for (var prod in data.products)
                      ListTile(
                        title: Text("${prod.name}"),
                        subtitle: Text("R\$${prod.price}"),
                        onTap: () {
                          data.setProduct(prod);
                          if (widget.onListClick != null)widget.onListClick(prod);
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_right),
                          onPressed: () {
                            data.setProduct(prod);
                            if (widget.onListClick != null)widget.onListClick(prod);
                          },
                        ),
                      ),
                  ],
                ).toList(),
              ),
            ),
          );
        }),
      ],
    );
  }
}
