import 'package:comies/components/async.comp.dart';
import 'package:comies/components/responsebar.comp.dart';
import 'package:comies/components/textfield.comp.dart';
import 'package:comies/components/titlebox.comp.dart';
import 'package:comies/controllers/product.controller.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/utils/declarations/themes.dart';
import 'package:comies/utils/notifier.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';

class ProductFormComponent extends StatefulWidget {
  final Function afterDelete;
  final Function afterSave;
  final bool isAddition;
  ProductFormComponent({this.afterSave, this.afterDelete, this.isAddition = false});

  @override
  ProductForm createState() => ProductForm();
}

class ProductForm extends State<ProductFormComponent> {

  TextEditingController unityController = new TextEditingController();

  LoadStatus status;

  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;

  void onSave() => Provider.of<ProductsController>(context, listen: false).addProduct()
    .then((value) => ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value.notifications[0])))
    .catchError((value) => ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value.notifications[0])));
  void onDelete() => Provider.of<ProductsController>(context, listen: false).removeProduct()
    .then((value) => ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value.notifications[0])))
    .catchError((value) => ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value.notifications[0])));
  void onUpdate() => Provider.of<ProductsController>(context, listen: false).updateProduct()
    .then((value) => ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value.notifications[0])))
    .catchError((value) => ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value.notifications[0])));

  @override
  Widget build(BuildContext context) {
    
    return Consumer<ProductsController>(builder: (context, data, child) {
      if (!widget.isAddition && data.product != null) unityController.text = data.product.unity.index.toString();
      return AsyncComponent(
          data: widget.isAddition ? {widget: "new"} : data.product,
          messageIfNullOrEmpty: "Selecione um produto para ver seus detalhes",
          status: data.productLoadStatus,
          snackbar: data.snackbar,
          child: widget.isAddition || data.product != null 
            ? Form(
              child: ListView(padding: EdgeInsets.all(30), 
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleBox("Informações básicas"),
                      Row(
                        children: [
                          Expanded( flex: 40,
                            child: TextFieldComponent(
                              fieldName: "Código",
                              value: data.product.code,
                              icon: Icon(Icons.qr_code), onFieldChange: (c) => data.product.code = c,
                            )),
                          SizedBox(width: 10),
                          Expanded(flex: 60,
                            child: TextFieldComponent(
                              fieldName: "Nome do produto",
                              value: data.product.name,
                              icon: Icon(Icons.category), onFieldChange: (c) => data.product.name = c,
                            ))
                        ],
                      ),
                      SizedBox(height: 20),
                      TextFieldComponent(
                        fieldName: "Preço",
                        value: (data.product.price  ?? 0.00).toString(),
                        textInputType: TextInputType.numberWithOptions(decimal: true),
                        icon: Icon(Icons.attach_money), onFieldChange: (c) => data.product.price = double.tryParse(c),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleBox("Detalhes"),
                      Row(
                        children: [
                          Expanded(flex: 50,
                            child: SelectFormField(
                              decoration: InputDecoration(labelText: "Unidade", suffixIcon: Icon(Icons.format_list_numbered)),
                              enableSearch: true,
                              controller: unityController,
                              onChanged: (value) => data.product.unity = Unity.values[int.tryParse(value)],
                              items: [{"label": "Quilogramas", "value": "0"}, {"label": "Miligramas", "value": "1"}, 
                                      {"label": "Litros", "value": "2"}, {"label": "Mililitros", "value": "3"}, {"label": "Unidade", "value": "4"}],
                            )
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 50,
                            child: TextFieldComponent(
                              fieldName: "Mínimo",
                              value: (data.product.min ?? 0.00).toString(),
                              onFieldChange: (s) => data.product.min = double.tryParse(s),
                              textInputType: TextInputType.numberWithOptions(decimal: true),
                              icon: Icon(Icons.shopping_cart),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  child
          ]))
          : Center()
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!widget.isAddition) OutlinedButton.icon(onPressed: onDelete, icon: Icon(Icons.delete), label: Text("EXCLUIR")),
          SizedBox(width: 20),
          ElevatedButton(onPressed: !widget.isAddition ? onUpdate : onSave, child: Text(!widget.isAddition ? "ATUALIZAR" : "SALVAR"), style: successButton) 
      ]),
    );
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
