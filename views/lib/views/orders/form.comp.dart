import 'package:comies/components/async.comp.dart';
import 'package:comies/services/costumers.service.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/utils/selections/costumer-order.selection.dart';
import 'package:comies/views/costumers/form.comp.dart';
import 'package:comies/views/costumers/list.comp.dart';
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
  LoadStatus status;
  int step = 0;
  List<int> clickedSteps = [];

  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
  bool hasID() => widget.id != null && widget.id != 0;


  InputDecoration decorateField(String label, IconData icon) =>
      InputDecoration(labelText: label, suffixIcon: Icon(icon));

  StepState getCostumerStepState(){
    if (step == 0) return StepState.editing;
    if ((!costumerOrderSelection.valid) && clickedSteps.contains(0)) return StepState.error;
    if (costumerOrderSelection.valid) return StepState.complete;
    return StepState.indexed;
  }

  @override
  void initState() {
    // if (hasID()) getCostumer(setLoading: true);
    super.initState();
  }

  @override
  void didUpdateWidget(OrderFormComponent oldWidget) {
    // if (hasID()) getCostumer(setLoading: true);
    super.didUpdateWidget(oldWidget);
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
          onStepTapped: (index) => setState((){step = index; clickedSteps.add(index);}),
          controlsBuilder: (BuildContext context, { VoidCallback onStepContinue, VoidCallback onStepCancel }) {
              return Row(
                children: <Widget>[
                  SizedBox(height: 50),
                  TextButton(
                    onPressed: step < 3 ? () => setState((){clickedSteps.add(step); step++; }) : null,
                    child: const Text('PRÓXIMO'),
                  ),
                  SizedBox(width: 20),
                  TextButton(
                    onPressed: step > 0 ? () => setState((){clickedSteps.add(step); step--; }) : null,
                    child: const Text('VOLTAR'),
                  ),
                ],
              );
          },
          steps: [
            Step(
              state: getCostumerStepState(),
                title: Text('Selecione ou adidione um cliente'),
                content: SizedBox(height: 500, child: CostumerSelection(selection: costumerOrderSelection))),

            Step(
                title: Text('Selecione ou adidione um cliente'),
                content: Form(
                  child: TextButton(child: Text("hu"), onPressed: () => null),
                )),
            Step(
                title: Text('Selecione ou adidione um cliente'),
                content: Form(
                  child: TextButton(child: Text("hu"), onPressed: () => null),
                )),
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
                            onListClick: (value) =>
                                setState((){id = value.id; widget.selection.costumer = value; })))),
                if (hasID())
                  Expanded(
                      flex: 65,
                      child: Center(
                          child: Container(
                              width: 600,
                              child: CostumerFormComponent(
                                onSelectedAddress: (address){widget.selection.address = address;},
                                readonly: true,
                                id: id,
                                ))))
                else
                  Expanded(
                      flex: 65,
                      child: Center(
                          child: Text(
                              "Clique em um cliente para ver os detalhes.")))
              ])
            : RefreshIndicator(
                child: GridView.count(
                    padding: EdgeInsets.all(16),
                    crossAxisCount: 1,
                    children: [
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        child: CostumersListComponent(
                            onListClick: (value){
                              setState((){});
                            }),
                      )
                    ]),
                onRefresh: () => new Future(() => setState(() {})),
              );
  }
}
