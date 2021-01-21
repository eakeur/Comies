import 'package:comies/components/layer.comp.dart';
import 'package:comies/services/costumers.service.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/utils/declarations/menu.dart';
import 'package:comies/views/costumers/form.comp.dart';
import 'package:comies/views/costumers/list.comp.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';

class CostumersScreen extends StatefulWidget {
  final MenuEntries menu;
  final int id;
  CostumersScreen({Key key, this.menu, this.id}) : super(key: key);

  @override
  Costumers createState() => Costumers();
}

class Costumers extends State<CostumersScreen> {
  CostumersService service = new CostumersService();
  List<Widget> costumerActions = [];

  bool hasID() => widget.id != null;

  void onRender(List<Widget> widgets) => setState(() {
        costumerActions = widgets;
      });

  @override
  Widget build(BuildContext context) {
    return hasID()
        ? Scaffold(
            //The top bar app
            appBar: AppBar(
              title: Text('Cliente'),
              elevation: 8,
              actions: costumerActions,
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
              title: Text('Clientes'),
              elevation: 8,
            ),

            //The body of the app
            body: GeneralScreen(service: service, onRender: onRender),

            // The FAB button at the bottom of the screen
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => new CostumersScreen(
                            menu: widget.menu,
                            id: 0,
                          ))),
              tooltip: 'Adicionar clientes',
              child: Icon(Icons.add),
            ),
          );
  }
}

class GeneralScreen extends StatefulWidget {
  final CostumersService service;
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
    getCostumers();
    super.initState();
  }

  void getCostumers() {
    setState(() {
      status = LoadStatus.loading;
    });
    widget.service.getCostumers().then((value) => setState(() {
          status = LoadStatus.loaded;
        }));
  }

  void onSearchFieldChange(String change) {
    widget.service.addProperty((p) => p.firstName = change);
  }

  void renderDetails(int id) => setState(() {
        this.id = id;
      });

  void showProductDetails(int id) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => new CostumersScreen(id: id)));

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
                  child: CostumersListComponent(
                    service: widget.service,
                    onListClick: renderDetails,
                    onSearchClick: getCostumers,
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
                        "Aqui irão informações gerais sobre os clientes e seus resultados de compras"),
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
                  child: CostumersListComponent(
                    service: widget.service,
                    onListClick: renderDetails,
                    onSearchClick: getCostumers,
                    status: status,
                    onSearchFieldChange: onSearchFieldChange,
                  ),
                ),
              ],
            ),
            onRefresh: () => new Future(() {
              getCostumers();
            }),
          );
  }
}

class DetailedScreen extends StatefulWidget {
  final CostumersService service;
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
    // var costm = widget.service.createProduct();
    // costm.code = codeController.text;
    // costm.name = nameController.text;
    // costm.price = double.parse(priceController.text);
    // costm.min = int.parse(minController.text);
    // costm.active = true;
    // costm.unity = Unity.values[int.parse(unityController.text)];
    // costm.id = widget.id;
    // widget.id == 0
    //     ? widget.service.addCostumer(costm)
    //     : widget.service.updateCostumer(costm);
  }

  void onDelete() {
    widget.service.removeCostumer(widget.id).then((value) => setState(() {}));
  }

  void onLoad() {
    if (widget.id != null && widget.id != 0) {
      setState(() {
        status = LoadStatus.loading;
        lastID = widget.id;
      });
      widget.service.getById(widget.id).then((costumer) => setState(() {
            // codeController.text = costumer.code;
            // nameController.text = costumer.name;
            // priceController.text = costumer.price.toString();
            // minController.text = costumer.min.toString();
            // unityController.text = costumer.unity.index.toString();
            status = LoadStatus.loaded;
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (lastID != widget.id) onLoad();
    return CostumerFormComponent(
      status: status,
      service: widget.service,
      onSave: onSave,
      onDelete: onDelete,
      name: nameController,
      isUpdate: widget.id != null && widget.id != 0,
    );
  }
}
