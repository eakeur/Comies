import 'package:comies/components/async.comp.dart';
import 'package:comies/services/products.service.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';


class ProductFormComponent extends StatefulWidget {
  final Function afterDelete;
  final Function afterSave;
  final int id;
  ProductFormComponent({this.afterSave, this.afterDelete, this.id});
  @override
  ProductForm createState() => ProductForm();
}

class ProductForm extends State<ProductFormComponent> {
  TextEditingController codeController = new TextEditingController();

  TextEditingController nameController = new TextEditingController();

  TextEditingController priceController = new TextEditingController();

  TextEditingController unityController = new TextEditingController();

  TextEditingController minController = new TextEditingController();

  ProductsService service = new ProductsService();

  Product product = new Product();

  LoadStatus status;

  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
  bool hasID() => widget.id != null && widget.id != 0;

  void onDropdownChange(int change) =>
      setState(() => unityController.text = change.toString());

  void onSave() {
    product.code = codeController.text;
          product.name = nameController.text;
          product.price = double.parse(priceController.text);
          product.min = double.parse(minController.text);
          product.active = true;
          product.unity = Unity.values[int.parse(unityController.text)];
          product.id = widget.id;
          hasID()
              ? service.updateProduct(product).then((value){
                new Future.delayed(const Duration(milliseconds: 750), () => widget.afterSave());
                
              })
              : service.addProduct(product).then((value){
                new Future.delayed(const Duration(milliseconds: 750), () => widget.afterSave());
              });
  }

  void onDelete() => showDialog(
      context: context,
      builder: (context) =>
        DeleteDialog(onDelete:(){
          service.removeProduct(widget.id).then((value){
                new Future.delayed(const Duration(milliseconds: 750), () => widget.afterDelete());
              });
        })
  );

  void getProduct(){
    setState(() => status = LoadStatus.loading);
    service.getById(widget.id).then((prod) => setState(() {
            product = prod;
            codeController.text = product.code;
            nameController.text = product.name;
            priceController.text = product.price.toString();
            minController.text = product.min.toString();
            unityController.text = product.unity.index.toString();
            status = LoadStatus.loaded;
          }));
  }

  InputDecoration decorateField(String label, IconData icon) =>
      InputDecoration(labelText: label, suffixIcon: Icon(icon));

  @override
  void initState() {
    if (hasID()) getProduct();
    super.initState();
  }

    @override
  void didUpdateWidget(ProductFormComponent oldWidget){
    if (hasID()) getProduct();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    //Text forms declarations before rendering anything
    service.setContext(context);
    return AsyncComponent(
        data: {'id': widget.id},
        status: status,
        child: Form(
            child: ListView(padding: EdgeInsets.all(30), children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [
                Text("Informações básicas",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    textAlign: TextAlign.left),
                Divider(thickness: 1.2, height: 20.2)
              ]),
              Row(
                children: [
                  Expanded(
                    flex: 40,
                    //Product code input
                    child: TextFormField(
                        controller: codeController,
                        autofocus: true,
                        readOnly: hasID(),
                        keyboardType: TextInputType.text,
                        decoration: decorateField("Código", Icons.qr_code),
                        maxLines: 1),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 60,
                    // Product name input
                    child: TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        decoration: decorateField("Nome", Icons.category),
                        maxLines: 1),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: decorateField("Preço", Icons.attach_money),
                  maxLines: 1),
              SizedBox(height: 20),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [
                Text("Detalhes do produto",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    textAlign: TextAlign.left),
                Divider(thickness: 1.2, height: 20.2)
              ]),
              Row(
                children: [
                  Expanded(
                      flex: 30,
                      child: Column(children: [
                        SizedBox(height: 17),
                        DropdownButton(
                            isExpanded: true,
                            value: unityController.text == ""
                                ? null
                                : int.parse(unityController.text),
                            onChanged: onDropdownChange,
                            items: [
                              DropdownMenuItem(
                                  child: Text("Quilogramas"), value: 0),
                              DropdownMenuItem(
                                  child: Text("Miligramas"), value: 1),
                              DropdownMenuItem(child: Text("Litros"), value: 2),
                              DropdownMenuItem(
                                  child: Text("Mililitros"), value: 3),
                              DropdownMenuItem(
                                  child: Text("Unidade"), value: 4),
                            ])
                      ])),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 70,
                    child: TextFormField(
                        controller: minController,
                        keyboardType: TextInputType.number,
                        decoration: decorateField(
                            "Quantidade mínima", Icons.shopping_cart),
                        maxLines: 1),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
          Row(children: [
            ElevatedButton.icon(
                onPressed: onSave,
                icon: Icon(Icons.save),
                label: Text(hasID() ? "Atualizar" : "Salvar")),
            SizedBox(width: 20),
            if (hasID())
              ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.red[700]),
                  ),
                  onPressed: onDelete,
                  icon: Icon(Icons.delete),
                  label: Text("Excluir"))
          ])
        ])));
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