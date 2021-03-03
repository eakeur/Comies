import 'package:carousel_slider/carousel_slider.dart';
import 'package:comies/controllers/order.controller.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/views/products/list.comp.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';

class ProductsSelectionGrid extends StatelessWidget {
  final CarouselController slider = new CarouselController();
  final NewOrderController controller = new NewOrderController();

  @override
  Widget build(BuildContext context) {
    bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
    return isBigScreen()
        ? Row(
            children: [
              Expanded(
                flex: 35,
                child: Card(margin: EdgeInsets.all(0), elevation: 8, child: ProductsListComponent(onListClick: (product) => controller.setItem(product)))
              ),
              Expanded(flex: 65, child: ProductsSelection())
            ]
          )
        : CarouselSlider(
          options: CarouselOptions(
            height: 1000, enableInfiniteScroll: false, pageSnapping: true, enlargeCenterPage: true, scrollDirection: Axis.vertical
          ),
          items: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
              child: ProductsListComponent(onListClick: (product){ controller.setItem(product); slider.nextPage();}),
            ),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
              child: ProductsSelection(),
            ),
          ],
          carouselController: slider,
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
  NewOrderController controller = new NewOrderController();
  TextEditingController edition = new TextEditingController();

  void onCancel() => setState((){controller.cancelItemEdition();});
  void onSave() => setState((){controller.addItem();});
  void onRemove(Item item) => setState((){controller.removeItem(item);});
  void showItemsDialog() => Scaffold.of(context).showBottomSheet((context){
    return Card(
      elevation: 10,
      child: Container(
      height: MediaQuery.of(context).size.height -300,
      padding: EdgeInsets.all(15),
      child: Column(children: [
        ProductSelectionList(items: controller.items, onRemove: (item){onRemove(item); Navigator.pop(context);}, onTap: (product){controller.setItem(product); Navigator.pop(context);})
      ])),
    );
    }, elevation: 10);
  bool get isBigScreen => MediaQuery.of(context).size.width > widthDivisor;

  @override
  void initState(){
    super.initState();
    NewOrderController.addListener(this.hashCode.toString(), NewOrderTriggerType.itemCreation, (item) => 
      setState((){controller.item = item; edition.text = item.quantity.toString();}));
    NewOrderController.addListener(this.hashCode.toString(), NewOrderTriggerType.itemQuantityChange, (item) =>
      setState((){var p = edition.selection; edition.text = item.quantity.toString(); edition.selection = p;}));
  }

  @override
  void dispose(){
    super.dispose();
    NewOrderController.removeListeners(this.hashCode.toString());
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [
        if (controller.hasItemPositioned)
            Expanded(flex: isBigScreen ? 50 : 100, 
              child: ProductSelectionComponent(
                onSave: onSave, edition: edition, onCancel: onCancel, item: controller.item, 
                onChange: controller.changeItemQuantity, onChangeEdition: controller.onItemQuantityChange,
               )
            ),
        if (controller.hasItemPositioned && isBigScreen) VerticalDivider(thickness: 1.2),
        isBigScreen  
            ? Expanded(flex: 50, child: controller.items.isNotEmpty
              ? ProductSelectionList(items: controller.items, onRemove: onRemove, onTap: controller.setItem)
              : Center(child: Text("Nenhum produto selecionado ainda"))
            )
            : Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
              child: controller.items.isNotEmpty ? ListTile(
                trailing: TextButton(onPressed: showItemsDialog, child: Text("VER MAIS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),)),
              ) : Center(child: Text("Nenhum produto selecionado ainda"))
            ) 
      ];
    return isBigScreen ? Row(children: content) : Column(children: content, verticalDirection: controller.items.isEmpty ? VerticalDirection.up : VerticalDirection.down );
  }
}

class ProductSelectionList extends StatelessWidget {
  final List<Item> items;
  final Function(Product) onTap;
  final Function(Item) onRemove;

  ProductSelectionList({this.items, this.onRemove, this.onTap});

  @override
  Widget build(BuildContext context) {
    List<int> groups = [];
    items.forEach((item) {
      if (!groups.contains(item.group)) groups.add(item.group);
    });
    return Column(children: groups.isNotEmpty
        ? [
            Text("Produtos selecionados",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left),
            for (var group in groups)
              Column(
                children: [
                  for (var item in items.where((item) => item.group == group))
                    ListTile(
                        leading: Icon(Icons.category),
                        title: Text(item.product.name,
                            style: TextStyle(fontSize: 18)),
                        trailing: IconButton(
                            onPressed: () => onRemove(item),
                            icon: Icon(Icons.remove)),
                        subtitle: Text(
                            "QTDE: ${item.quantity}  |  R\$ " +
                                (item.quantity * item.product.price).toString(),
                            style: TextStyle(fontSize: 18)),
                        onTap: () => onTap(item.product))
                ],
              )
          ]
        : []);
  }
}

class ProductSelectionComponent extends StatelessWidget {
  final Function onSave;
  final Function onCancel;
  final Function onGroup;
  final Item item;
  final TextEditingController edition;
  final Function(String) onChangeEdition;
  final Function(double) onChange;

  ProductSelectionComponent(
      {this.onSave,
      this.onCancel,
      this.onGroup,
      this.item,
      this.edition,
      this.onChange,
      this.onChangeEdition});

  @override
  Widget build(BuildContext context) {
    bool isBigScreen = MediaQuery.of(context).size.width > widthDivisor;
    return Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Adicionar produto",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            Divider(thickness: 1.2),
            ListTile(
              leading: Icon(Icons.category),
              title: Text(item.product.name, style: TextStyle(fontSize: 20)),
              subtitle: Text(
                  "Valor: R\$${item.product.price}  |  Mínimo: ${item.product.min}",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18)),
            ),
            ListTile(
              title: ProductQuantitySelectionComponent(
                  minimum: item.product.min,
                  edition: edition,
                  quantity: item.quantity,
                  onChangeEdition: onChangeEdition,
                  onChange: onChange
                  ),
              leading: isBigScreen ? Icon(Icons.shopping_cart) : null,
            ),
            ListTile(
              title: Text("TOTAL: "+(item.product.price*item.quantity).toString(), style: TextStyle(fontSize: 18)),
              leading: Icon(Icons.calculate)
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(child: Text("Cancelar"), onPressed: onCancel),
                SizedBox(width: 10),
                ElevatedButton(child: Text("Salvar"), onPressed: onSave)
              ],
            )
          ],
        ));
  }
}

class ProductQuantitySelectionComponent extends StatelessWidget {
  final Function(double) onChange;
  final double minimum;
  final double quantity;
  final Product product;
  final TextEditingController edition;
  final Function(String) onChangeEdition;

  ProductQuantitySelectionComponent(
      {this.onChange,
      this.minimum,
      this.product,
      this.quantity,
      this.edition,
      this.onChangeEdition});

  ElevatedButton quantityChangerButton(IconData icon) {
    return ElevatedButton(
        onPressed: icon == Icons.remove
            ? !(quantity - minimum < minimum)
                ? () => onChange(quantity - minimum)
                : null
            : () => onChange(quantity + minimum),
        style: ButtonStyle(
            backgroundColor: icon == Icons.remove
                ? MaterialStateProperty.all(Colors.red)
                : MaterialStateProperty.all(Colors.green)),
        child: Container(width: 20, height: 50, child: Icon(icon, size: 16)));
  }

  

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          quantityChangerButton(Icons.remove),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            width: 100,
            height: 50,
            child: Center(
                child: TextFormField(
                    controller: edition,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onChanged: onChangeEdition,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(border: InputBorder.none),
                    style: TextStyle(fontSize: 24, color: Colors.grey[850]))),
          ),
          quantityChangerButton(Icons.add)
        ],
      ),
    );
  }
}
