import 'package:comies/components/layer.comp.dart';
import 'package:comies/services/products.service.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/utils/declarations/menu.dart';
import 'package:comies/views/products/form.comp.dart';
import 'package:comies/views/products/list.comp.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  final MenuEntries menu;
  final int id;
  ProductsScreen({Key key, this.menu, this.id}) : super(key: key);

  @override
  Products createState() => Products();
}

class Products extends State<ProductsScreen> {
  ProductsService service = new ProductsService();
  List<Widget> productActions = [];

  bool hasID() => widget.id != null;

  void onRender(List<Widget> widgets) => setState(() {
        productActions = widgets;
      });

  @override
  Widget build(BuildContext context) {
    return hasID()
        ? Scaffold(
            //The top bar app
            appBar: AppBar(
              title: Text('Produto'),
              elevation: 8,
              actions: productActions,
            ),

            //The body of the app
            body: Container(
              child: Center(
                child: DetailedScreen(
                    id: widget.id, service: service, onRender: onRender),
              ),
            ),
          )
        : Scaffold(
            drawer: widget.menu.drawer(context),

            //The top bar app
            appBar: AppBar(
              title: Text('Produtos'),
              elevation: 8,
            ),

            //The body of the app
            body: GeneralScreen(service: service, onRender: onRender),

            // The FAB button at the bottom of the screen
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => new ProductsScreen(
                            menu: widget.menu,
                            id: 0,
                          ))),
              tooltip: 'Adicionar produto',
              child: Icon(Icons.add),
            ),
          );
  }
}

class GeneralScreen extends StatefulWidget {
  final ProductsService service;
  final Function(List<Widget>) onRender;

  GeneralScreen({this.service, this.onRender});

  @override
  General createState() => General();
}

class General extends State<GeneralScreen> {
  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
  LoadStatus status = LoadStatus.loaded;
  int id;

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  void getProducts() {
    setState(() {
      status = LoadStatus.loading;
    });
    widget.service.getProducts().then((value) => setState(() {
          status = LoadStatus.loaded;
        }));
  }

  void onSearchFieldChange(String change) {
    widget.service.addProperty((p) => p.name = change);
  }

  void renderDetails(int id) => setState(() {
        this.id = id;
      });

  void showProductDetails(int id) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => new ProductsScreen(id: id)));

  Widget renderDetailedProductWidget() {
    return new Expanded(
        flex: 65,
        child: Center(
          child: Container(
            width: 600,
            child: DetailedScreen(
              service: widget.service,
              id: id,
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return isBigScreen()
        ? Row(
            children: [
              Expanded(
                flex: 35,
                child: Card(
                  margin: EdgeInsets.all(0),
                  elevation: 8,
                  child: ProductsListComponent(
                    service: widget.service,
                    onListClick: renderDetails,
                    onSearchClick: getProducts,
                    status: status,
                    onSearchFieldChange: onSearchFieldChange,
                  ),
                ),
              ),
              if (id != null)
                renderDetailedProductWidget()
              else
                Expanded(
                  flex: 65,
                  child: Center(
                    child: Text(
                        "Aqui irão informações gerais sobre os produtos e seus resultados de vendas"),
                  ),
                )
            ],
          )
        : RefreshIndicator(
            child: GridView.count(
              padding: EdgeInsets.all(16),
              crossAxisCount: 1,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: ProductsListComponent(
                    service: widget.service,
                    onListClick: showProductDetails,
                    onSearchClick: getProducts,
                    status: status,
                    onSearchFieldChange: onSearchFieldChange,
                  ),
                ),
              ],
            ),
            onRefresh: () => new Future(() {
              getProducts();
            }),
          );
  }
}

class DetailedScreen extends StatefulWidget {
  final ProductsService service;
  final int id;
  final Function(List<Widget>) onRender;

  DetailedScreen({this.service, this.id, this.onRender});

  @override
  Detailed createState() => Detailed();
}

class Detailed extends State<DetailedScreen> {
  TextEditingController codeController = new TextEditingController();

  TextEditingController nameController = new TextEditingController();

  TextEditingController priceController = new TextEditingController();

  TextEditingController unityController = new TextEditingController();

  TextEditingController minController = new TextEditingController();

  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;

  int lastID;

  @override
  void initState() {
    onLoad();
    super.initState();
  }

  LoadStatus status = LoadStatus.loaded;

  void onSave() {
    var prod = widget.service.createProduct();
    prod.code = codeController.text;
    prod.name = nameController.text;
    prod.price = double.parse(priceController.text);
    prod.min = int.parse(minController.text);
    prod.active = true;
    prod.unity = Unity.values[int.parse(unityController.text)];
    prod.id = widget.id;
    widget.id == 0
        ? widget.service.addProduct(prod)
        : widget.service.updateProduct(prod);
  }

  void onDelete() {
    widget.service.removeProduct(widget.id).then((value) => setState(() {}));
  }

  void onLoad() {
    if (widget.id != null && widget.id != 0) {
      setState(() {
        status = LoadStatus.loading;
        lastID = widget.id;
      });
      widget.service.getById(widget.id).then((product) => setState(() {
            codeController.text = product.code;
            nameController.text = product.name;
            priceController.text = product.price.toString();
            minController.text = product.min.toString();
            unityController.text = product.unity.index.toString();
            status = LoadStatus.loaded;
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (lastID != widget.id) onLoad();
    return ProductFormComponent(
      status: status,
      service: widget.service,
      onSave: onSave,
      onDelete: onDelete,
      codeController: codeController,
      nameController: nameController,
      priceController: priceController,
      minController: minController,
      unityController: unityController,
      isUpdate: widget.id != null && widget.id != 0,
    );
  }
}
