import 'package:comies/components/async.comp.dart';
import 'package:comies/services/costumers.service.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/utils/selections/costumer-order.selection.dart';
import 'package:comies/views/costumers/form.comp.dart';
import 'package:comies/views/costumers/list.comp.dart';
import 'package:comies/views/products/edit.screen.dart';
import 'package:comies/views/products/form.comp.dart';
import 'package:comies/views/products/list.comp.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';

class OrderFormComponent extends StatefulWidget {
  final Function afterSave;
  final Function afterDelete;
  final int id;

  OrderFormComponent({Key key, this.id, this.afterSave, this.afterDelete})
      : super(key: key);

  @override
  OrderForm createState() => OrderForm();
}

class OrderForm extends State<OrderFormComponent> {
  CostumerOrderSelection costumerOrderSelection = new CostumerOrderSelection();
  List<Item> orderItems = [];
  LoadStatus status;
  int step = 0;
  List<int> clickedSteps = [];

  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
  bool hasID() => widget.id != null && widget.id != 0;

  InputDecoration decorateField(String label, IconData icon) =>
      InputDecoration(labelText: label, suffixIcon: Icon(icon));

  StepState getCostumerStepState() {
    if (step == 0) return StepState.editing;
    if ((!costumerOrderSelection.valid) && clickedSteps.contains(0))
      return StepState.error;
    if (costumerOrderSelection.valid) return StepState.complete;
    return StepState.indexed;
  }

  StepState getProductsStepState() {
    bool valid = orderItems.isNotEmpty &&
        orderItems.every((item) => item.quantity > 0.0) &&
        orderItems
            .every((item) => item.product != null && item.product.id != null) &&
        orderItems
            .map((order) => order.group)
            .map((group) =>
                orderItems.where((item) => item.group == group).fold<double>(0,
                    (previousValue, item) => previousValue + item.quantity) >=
                1)
            .toList()
            .every((groupStatus) => groupStatus);
    if (step == 1) return StepState.editing;
    if ((!valid) && clickedSteps.contains(1)) return StepState.error;
    if (valid) return StepState.complete;
    return StepState.indexed;
  }

  @override
  Widget build(BuildContext context) {
    // service.setContext(context);
    return AsyncComponent(
        animate: hasID(),
        data: {'widget': 1},
        status: status,
        child: Stepper(
          currentStep: step,
          onStepTapped: (index) => setState(() {
            step = index;
            clickedSteps.add(index);
          }),
          controlsBuilder: (BuildContext context,
              {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
            return Row(
              children: <Widget>[
                SizedBox(height: 50),
                TextButton(
                  onPressed: step + 1 < 2
                      ? () => setState(() {
                            clickedSteps.add(step);
                            step++;
                          })
                      : null,
                  child: const Text('PRÓXIMO'),
                ),
                SizedBox(width: 20),
                TextButton(
                  onPressed: step - 1 < 0
                      ? null
                      : () => setState(() {
                            clickedSteps.add(step);
                            step--;
                          }),
                  child: const Text('VOLTAR'),
                ),
              ],
            );
          },
          steps: [
            Step(
                state: getCostumerStepState(),
                title: Text('Selecione ou adicione um cliente'),
                content: SizedBox(
                    height: 500,
                    child:
                        CostumerSelection(selection: costumerOrderSelection))),
            Step(
                state: getProductsStepState(),
                title: Text('Selecione os produtos do pedido'),
                content: SizedBox(
                    height: 500,
                    child: ProductsSelection(selection: orderItems))),
          ],
        ));
  }
}

class DeleteDialog extends StatelessWidget {
  final Function onDelete;
  final Function onCancel;

  DeleteDialog({this.onDelete, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Deseja mesmo excluir este produto?"),
      content: Text("Esta ação não poderá ser desfeita."),
      actions: [
        TextButton(
            onPressed: () {
              if (onCancel != null) onCancel();
              Navigator.pop(context);
            },
            child: Text("Cancelar")),
        TextButton(
          onPressed: () {
            onDelete();
            Navigator.pop(context);
          },
          child: Text("Excluir", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

class CostumerSelection extends StatefulWidget {
  final CostumerOrderSelection selection;
  final Function onSelectionComplete;
  CostumerSelection({this.selection, this.onSelectionComplete});
  @override
  CostumerSelectionState createState() => CostumerSelectionState();
}

class CostumerSelectionState extends State<CostumerSelection> {
  CostumersService service = new CostumersService();
  int id;

  bool hasID() => id != null;
  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;

  @override
  Widget build(BuildContext context) {
    return isBigScreen()
        ? Row(children: [
            Expanded(
                flex: 35,
                child: Card(
                    margin: EdgeInsets.all(0),
                    elevation: 8,
                    child: CostumersListComponent(
                        onListClick: (value) => setState(() {
                              id = value.id;
                              widget.selection.costumer = value;
                            })))),
            if (hasID())
              Expanded(
                  flex: 65,
                  child: Center(
                      child: Container(
                          width: 600,
                          child: CostumerFormComponent(
                            onSelectedAddress: (address) {
                              widget.selection.address = address;
                            },
                            readonly: true,
                            id: id,
                          ))))
            else
              Expanded(
                  flex: 65,
                  child: Center(
                      child:
                          Text("Clique em um cliente para ver os detalhes.")))
          ])
        : RefreshIndicator(
            child: GridView.count(
                padding: EdgeInsets.all(16),
                crossAxisCount: 1,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: CostumersListComponent(onListClick: (value) {
                      setState(() {});
                    }),
                  )
                ]),
            onRefresh: () => new Future(() => setState(() {})),
          );
  }
}

class ProductsSelection extends StatefulWidget {
  final List<Item> selection;
  final Function onSelectionComplete;
  ProductsSelection({this.selection, this.onSelectionComplete});
  @override
  ProductsSelectionState createState() => ProductsSelectionState();
}

class ProductsSelectionState extends State<ProductsSelection> {
  bool hasID() => id != null;
  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
  Product product = new Product();

  int id;
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return isBigScreen()
        ? Row(children: [
            Expanded(
                flex: 35,
                child: Card(
                    margin: EdgeInsets.all(0),
                    elevation: 8,
                    child: ProductsListComponent(
                        onListClick: (value) => setState(() {
                              id = value.id;
                              product = value;
                            })))),
            if (hasID())
              Expanded(
                  flex: 65,
                  child: Center(
                      child: Container(
                          width: 900,
                          child:
                              ProductQuantitySelection(minimum: product.min))))
            else
              Expanded(
                  flex: 65,
                  child: Center(
                      child:
                          Text("Clique em um produto para ver os detalhes.")))
          ])
        : RefreshIndicator(
            child: GridView.count(
                padding: EdgeInsets.all(16),
                crossAxisCount: 1,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: ProductsListComponent(onListClick: (value) {
                      setState(() {
                        id = value.id;
                        product = value;
                      });
                    }),
                  )
                ]),
            onRefresh: () => new Future(() => setState(() {})),
          );
  }
}

class ProductQuantitySelection extends StatefulWidget {
  final Function onChange;
  final double minimum;
  ProductQuantitySelection({this.onChange, this.minimum});
  @override
  ProductsQuantitySelectionState createState() =>
      ProductsQuantitySelectionState();
}

class ProductsQuantitySelectionState extends State<ProductQuantitySelection> {
  TextEditingController edition;
  double quantity = 0;

  @override
  void initState() {
    setState(() {
      quantity = widget.minimum;
      edition = new TextEditingController(text: widget.minimum.toString());
    });
    super.initState();
  }

  @override
  void didUpdateWidget(ProductQuantitySelection c) {
    setState(() {
      quantity = widget.minimum;
      edition = new TextEditingController(text: widget.minimum.toString());
    });
    super.didUpdateWidget(c);
  }

  void onChangeEdition(String change) {
    try {
      var q = double.tryParse(change);
      if (q >= widget.minimum) {
        setState(() {
          quantity = q;
          edition.text = quantity.toString();
        });
      }
    } catch (e) {
      setState(() {
        edition.text = quantity.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => setState(() {
              if (!(quantity - widget.minimum < widget.minimum)) {
                quantity -= widget.minimum;
                edition.text = quantity.toString();
              }
            }),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red)),
            child: Container(width: 50, height: 50, child: Icon(Icons.remove)),
          ),
          Container(
            width: 100,
            height: 50,
            child: Center(
                child: TextFormField(
                    controller: edition,
                    onChanged: (change) {},
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 24, color: Colors.grey[850]))),
          ),
          ElevatedButton(
            onPressed: () => setState(() {
              quantity += widget.minimum;
              edition.text = quantity.toString();
            }),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green)),
            child: Container(width: 50, height: 50, child: Icon(Icons.add)),
          ),
        ],
      ),
    );
  }
}
