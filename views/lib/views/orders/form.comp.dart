import 'package:carousel_slider/carousel_slider.dart';
import 'package:comies/components/titlebox.comp.dart';
import 'package:comies/controllers/order.controller.dart';
import 'package:comies/controllers/product.controller.dart';
import 'package:comies/services/costumers.service.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/views/costumers/form.comp.dart';
import 'package:comies/views/costumers/list.comp.dart';
import 'package:comies/views/products/list.comp.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  int step = 0;
  List<int> clickedSteps = [];

  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;

  StepState getCostumerStepState(bool valid) {
    if (step == 0) return StepState.editing;
    if ((!valid) && clickedSteps.contains(0))
      return StepState.error;
    if (valid) return StepState.complete;
    return StepState.indexed;
  }

  StepState getProductsStepState(bool valid) {
    if (step == 1) return StepState.editing;
    if ((!valid) && clickedSteps.contains(1)) return StepState.error;
    if (valid) return StepState.complete;
    return StepState.indexed;

  }

  void onStepControllerClicked(int addOrRemove){
    setState(() {clickedSteps.add(step); step = step + addOrRemove;});
  }

  @override
  Widget build(BuildContext context) {
    // service.setContext(context);
    return 
    Stepper(
      currentStep: step,
      onStepTapped: (index) => setState(() {step = index;clickedSteps.add(index);}),
      controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) => 
      FormStepperControls(onPressed: onStepControllerClicked, step: step),
      steps: [
        Step(
            state: getCostumerStepState(true),
            title: TitleBox('Selecione ou adicione um cliente'),
            content: SizedBox(height: 600,
              child: ChangeNotifierProvider(create: (context) => CostumerOrderSelectionController(), child: CostumerSelection()))),
        Step(
          state: getProductsStepState(true),
          title: TitleBox('Selecione os produtos do pedido'),
          content: SizedBox(height: 600, 
            child: ChangeNotifierProvider(create:(context) => OrderItemsSelectionController(), child: ProductsSelection()))),
      ],
    );
  }
}

class FormStepperControls extends StatelessWidget {
  final Function onPressed;
  final int step;

  FormStepperControls({this.onPressed, this.step});

  @override
  Widget build(BuildContext context){
    return Row(
      children: [
        SizedBox(height: 50),
        TextButton(onPressed: step + 1 < 2 ? () => onPressed(1) : null, child: Text('PRÓXIMO')),
        SizedBox(width: 20),
        TextButton(onPressed: step - 1 < 0 ? null : () => onPressed(-1), child: const Text('ANTERIOR')),
      ],
    );
  }
}



class CostumerSelection extends StatefulWidget {
  final Function onSelectionComplete;
  CostumerSelection({this.onSelectionComplete});
  @override
  CostumerSelectionState createState() => CostumerSelectionState();
}

class CostumerSelectionState extends State<CostumerSelection> {
  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;

  void onListClick(Costumer costumer) => Provider.of<CostumerOrderSelectionController>(context, listen: false).setCostumer(costumer);

  @override
  Widget build(BuildContext context) {
    return isBigScreen()
        ? Row(
          children: [
            Expanded(flex: 35,
              child: Card(
                margin: EdgeInsets.all(0),
                elevation: 8,
                child: CostumersListComponent(onListClick: onListClick ))),
              Expanded(
                  flex: 65,
                  child: Center(child: CostumerSelectionComponent()))
          ])
        : Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: CostumersListComponent(onListClick: onListClick),
            );
  }
}

class CostumerSelectionComponent extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return Consumer<CostumerOrderSelectionController>(
      builder: (context, data, child){
        return Container(
          child: CostumerFormComponent(
            onSelectedAddress: data.setAddress,
            readonly: true,
            id: data.hasCostumer ? data.costumer.id : null,
          )
        );
      }
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
  CarouselController slider = new CarouselController();
  TextEditingController edition = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isBigScreen = MediaQuery.of(context).size.width > widthDivisor;
    Function(Product) onListClick =
        Provider.of<OrderItemsSelectionController>(context, listen: false).setItem;

    return ChangeNotifierProvider(create: (context) => ProductsController(),
      child: isBigScreen
        ? Row(children: [
            Expanded(
                flex: 35,
                child: Card(
                    margin: EdgeInsets.all(0),
                    elevation: 8,
                    child: ProductsListComponent(onListClick: onListClick))),
            Expanded(
                flex: 65,
                child: Row(
                  children: [
                    Expanded(flex: 50, child: ProductSelectionComponent(edition: edition)),
                    Expanded(flex: 50, child: ProductSelectedListComponent())
                  ],
                ))
          ])
        : CarouselSlider(
            items: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: ProductsListComponent(onListClick: (product) {
                  onListClick(product);
                  slider.nextPage(duration: Duration(milliseconds: 350));
                }),
              ),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: ProductSelectionComponent(edition: edition),
              ),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: ProductSelectedListComponent(),
              ),
            ],
            options: CarouselOptions(
                height: 10000,
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                viewportFraction: 0.99,
                disableCenter: true),
            carouselController: slider,
          )
    );
  }
}

class ProductSelectedListComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isBigScreen = MediaQuery.of(context).size.width > widthDivisor;
    return Consumer<OrderItemsSelectionController>(builder: (context, data, child) {
      return data.itemsGroups.isNotEmpty
          ? Column(children: [
              TitleBox("No carrinho", paint: !isBigScreen),
              for (var group in data.itemsGroups)
                Column(
                  children: [
                    for (var item
                        in data.items.where((item) => item.group == group))
                      ListTile(
                          leading: Icon(Icons.category),
                          title: Text(item.product.name,
                              style: TextStyle(fontSize: 18)),
                          trailing: IconButton(
                              onPressed: () => data.removeItem(item),
                              icon: Icon(Icons.remove)),
                          subtitle: Text(
                              "QTDE: ${item.quantity}  |  R\$ " +
                                  (item.quantity * item.product.price)
                                      .toString(),
                              style: TextStyle(fontSize: 18)),
                          onTap: () => data.setItem(item.product))
                  ],
                )
            ])
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text("Nenhum produto selecionado ainda"))
              ],
            );
    });
  }
}

class ProductSelectionComponent extends StatelessWidget {
  final TextEditingController edition;

  ProductSelectionComponent({this.edition});

  bool setController(String edit){edition.text = edit; return true;}

  @override
  Widget build(BuildContext context) {
    bool isBigScreen = MediaQuery.of(context).size.width > widthDivisor;

    return Consumer<OrderItemsSelectionController>(
        builder: (context, data, child){
          return Container(
            child: data.item != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleBox("Adicionar produto", paint: !isBigScreen),
                      ListTile(
                        leading: Icon(Icons.category),
                        title: Text(data.item.product.name,
                            style: TextStyle(fontSize: 20)),
                        subtitle: Text(
                            "Valor: R\$${data.item.product.price}  |  Mínimo: ${data.item.product.min}",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 18)),
                      ),
                      if (setController(data.item.quantity.toString()))ListTile(
                        title:TextFormField(
                          controller: edition,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          onChanged: (String change) {
                            change = change.replaceAll(',', '.');
                            var q = double.tryParse(change);
                            if (q >= data.item.product.min) {
                              data.setItemQuantity(q % data.item.product.min == 0 ? q : q - (q % data.item.product.min));
                            }
                          },
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            prefix: IconButton(icon:Icon(Icons.remove), onPressed: !(data.item.quantity - data.item.product.min < data.item.product.min)? () => data.setItemQuantity(data.item.quantity - data.item.product.min): null),
                            suffix: IconButton(icon:Icon(Icons.add), onPressed: () => data.setItemQuantity(data.item.quantity + data.item.product.min))),
                          style: TextStyle(fontSize: 24)
                        ),
                      ),

                      ListTile(
                          title: Text(
                              "TOTAL: " +
                                  (data.item.product.price * data.item.quantity)
                                      .toString(),
                              style: TextStyle(fontSize: 18)),
                          leading: Icon(Icons.calculate)),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            child: Text("CANCELAR"),
                            onPressed: () => data.setItem(null)),
                          SizedBox(width: 10),
                          ElevatedButton(
                            child: Text("SALVAR"),
                            onPressed: () => data.addItem(data.item))
                          ],
                        ),
                      )
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Center(child: Text("Selecione um produto"))]));
      }
    );
  }
}
