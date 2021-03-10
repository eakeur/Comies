import 'package:carousel_slider/carousel_slider.dart';
import 'package:comies/components/async.comp.dart';
import 'package:comies/components/titlebox.comp.dart';
import 'package:comies/controllers/costumer.controller.dart';
import 'package:comies/controllers/order.controller.dart';
import 'package:comies/controllers/product.controller.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/utils/declarations/themes.dart';
import 'package:comies/views/costumers/form.comp.dart';
import 'package:comies/views/costumers/list.comp.dart';
import 'package:comies/views/products/list.comp.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';

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
    ChangeNotifierProvider(create: (context) => OrderController(),
      child: Stepper(
      currentStep: step,
      onStepTapped: (index) => setState(() {step = index;clickedSteps.add(index);}),
      controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) => 
      FormStepperControls(onPressed: onStepControllerClicked, step: step),
      steps: [
        Step(
            state: getCostumerStepState(true),
            title: TitleBox('Selecione ou adicione um cliente'),
            content: SizedBox(height: 400,
              child: CostumerSelection())),
        Step(
          state: getProductsStepState(true),
          title: TitleBox('Selecione os produtos do pedido'),
          content: SizedBox(height: 400, 
            child: ProductsSelection())),
        
        Step(
          state: getProductsStepState(true),
          title: TitleBox('Detalhes do pedido'),
          content: SizedBox(height: 400, 
            child: OrderRevisionComponent())),
        ],
      )
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
        TextButton(onPressed: step - 1 < 0 ? null : () => onPressed(-1), child: const Text('ANTERIOR')),
        SizedBox(width: 20),
        TextButton(onPressed: step + 1 < 3 ? () => onPressed(1) : null, child: Text('PRÓXIMO'))
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
  CarouselController slider = new CarouselController();
  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
  void onListClick(Costumer costumer) => Provider.of<OrderController>(context, listen: false).setCostumer(costumer);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CostumerController(),
      child: isBigScreen()
        ? Row(
          children: [
            Expanded(flex: 35,
              child: Card(
                margin: EdgeInsets.all(0),
                elevation: 8,
                child: CostumersListComponent(onListClick: onListClick ))),
              Expanded(
                  flex: 65,
                  child: Center(child: CostumerFormComponent(onAddressTap: Provider.of<OrderController>(context, listen: false).setAddress)))
          ])
        : CarouselSlider(
            items: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: CostumersListComponent(onListClick: (cost){
                  onListClick(cost); slider.nextPage(duration: Duration(milliseconds: 350));
                })
              ),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: CostumerFormComponent(onAddressTap: Provider.of<OrderController>(context, listen: false).setAddress),
              )
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
        Provider.of<OrderController>(context, listen: false).setItem;

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
    return Consumer<OrderController>(builder: (context, data, child) {
      return Column(
        children: [
          Container(
            height: 350,
            child: data.itemsGroups.isNotEmpty
          ? ListView(children: [
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
            ),
          ),
          Container(
            height: 50,
            child: ListTile(
              title: Text("TOTAL: R\$ "+data.totalPrice.toString()),
              leading: Icon(Icons.add_chart)
            )
          )
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

    return Consumer<OrderController>(
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



class OrderRevisionComponent extends StatefulWidget {
  @override
  _OrderRevisionComponentState createState() => _OrderRevisionComponentState();
}
class _OrderRevisionComponentState extends State<OrderRevisionComponent> {
    CarouselController slider = new CarouselController();
    bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
    void onListClick(Costumer costumer) => Provider.of<OrderController>(context, listen: false).setCostumer(costumer);

  Widget getDetailed(OrderController pr){
    return ListView(
      children:[
        TitleBox("RESUMO DO PEDIDO"),
        if (pr.costumer != null)ListTile(
          title:Text(pr.costumer.name), leading: Icon(Icons.person), 
          subtitle: (pr.costumer.phones != null && pr.costumer.phones.isNotEmpty) ? Text("(${pr.costumer.phones[0].ddd}) ${pr.costumer.phones[0].number}"):null),
        if (pr.address != null) ListTile(
              title: Text("${pr.address.street}, ${pr.address.number} - ${pr.address.district}",softWrap: true),
              subtitle: Text("${pr.address.city} - ${pr.address.state} - ${pr.address.reference}",softWrap: true),
              leading: Icon(Icons.map)),
        if (pr.order.deliverType != null) ListTile(
              title: Text(pr.deliverTypeText ,softWrap: true),
              leading: Icon(Icons.person_pin_circle_outlined)),
        if (pr.order.payment != null) ListTile(
              title: Text(pr.paymentMethodText ,softWrap: true),
              leading: Icon(Icons.credit_card)),
        if (pr.areItemsValid && pr.isCostumerValid && pr.areDetailsValid) Container(
          child: AsyncButton(icon: Icon(Icons.save), text: "SALVAR", style: successButton, 
                    onPressed: pr.addOrder,
                    isLoading: false),
        )

      ]
    ); 
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderController>(
      builder: (context, data, child){
        return isBigScreen()
        ? Row(
          children: [
            Expanded(flex: 25,
              child: Card(
                margin: EdgeInsets.all(0),
                elevation: 8,
                child: Container(padding: EdgeInsets.all(10) ,child: OrderPaymentComponent()))),
              Expanded(
                  flex: 35,
                  child: ProductSelectedListComponent()),
              Expanded(
                  flex: 40,
                  child: getDetailed(data))
          ])
        : CarouselSlider(
            items: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: OrderPaymentComponent()
              ),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: ProductSelectedListComponent(),
              ),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: getDetailed(data),
              )
            ],
            options: CarouselOptions(
                height: 10000,
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                viewportFraction: 0.99,
                disableCenter: true),
            carouselController: slider,
          );
      },
    );
  }
}




class OrderPaymentComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController paymentMethodC = new TextEditingController();
    return Consumer<OrderController>(
      builder: (context, data, child){
        return Container(
          padding: EdgeInsets.all(10),
          child:Column(
            children: [
              TitleBox("Forma de pagamento"),
              SelectFormField(
                decoration: InputDecoration(labelText: "Forma de pagamento", suffixIcon: Icon(Icons.payment)),
                enableSearch: true,
                enableInteractiveSelection: true,
                enableSuggestions: true,
                controller: paymentMethodC,
                onChanged: (value) => data.setPaymentMethod(PaymentMethod.values[int.tryParse(value)]),
                items: [{"label": "Dinheiro", "value": "0"}, {"label": "Débito", "value": "1"}, 
                  {"label": "Crédito", "value": "2"}, {"label": "Pix", "value": "3"}, {"label": "Transferência", "value": "4"}],
              ),
              SizedBox(height: 20),
              TitleBox("Tipo de entrega"),
              RadioListTile<DeliverType>(
                title: Text("Retirada", style: Theme.of(context).textTheme.caption),
                value: DeliverType.takeout,
                groupValue: data.order.deliverType,
                activeColor: Theme.of(context).accentColor,
                onChanged: (value) => data.setDeliverType(value),
              ),
              RadioListTile<DeliverType>(
                title: Text("Entrega", style: Theme.of(context).textTheme.caption),
                value: DeliverType.delivery,
                groupValue: data.order.deliverType,
                activeColor: Theme.of(context).accentColor,
                onChanged: (value) => data.setDeliverType(value),
              )
            ],
          )
        );
      }
    );
  }
}