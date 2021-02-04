import 'package:comies/components/async.comp.dart';
import 'package:comies/services/costumers.service.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/utils/validators.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';

class CostumerFormComponent extends StatefulWidget {
  final Function afterSave;
  final Function afterDelete;
  final int id;

  CostumerFormComponent({Key key, this.id, this.afterSave, this.afterDelete})
      : super(key: key);

  @override
  CostumerForm createState() => CostumerForm();
}

class CostumerForm extends State<CostumerFormComponent> {

  TextEditingController nameController = new TextEditingController();
  TextEditingController codeController = new TextEditingController();
  TextEditingController streetController = new TextEditingController();
  TextEditingController districtController = new TextEditingController();
  TextEditingController complementController = new TextEditingController();
  TextEditingController referenceController = new TextEditingController();
  TextEditingController numberController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  TextEditingController dddController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  CostumersService service = new CostumersService();

  Costumer costumer = new Costumer();

  LoadStatus status;

  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
  bool hasID() => widget.id != null && widget.id != 0;

  void onCodeChange(int change) =>
      setState(() => codeController.text = change.toString());

  void onSave() {
    costumer.name = nameController.text;

    if (isTextValid(codeController.text) && isTextValid(streetController.text)){
      var address = new Address();
      address.cep = codeController.text;
      address.street = streetController.text;
      address.number = int.parse(numberController.text);
      address.complement = complementController.text;
      address.reference = referenceController.text;
      address.district = districtController.text;
      address.city = cityController.text;
      address.state = stateController.text;
      address.country = countryController.text;
      costumer.addresses == null ? costumer.addresses = [address] : costumer.addresses.add(address);
    }

    if (isTextValid(dddController.text) && isTextValid(phoneController.text)){
      var phone = new Phone();
      phone.ddd = int.parse(codeController.text);
      phone.number = int.parse(phoneController.text);
      costumer.phones == null ? costumer.phones = [phone] : costumer.phones.add(phone);
    }
    
    costumer.id = widget.id;
          hasID()
              ? service.updateCostumer(costumer).then((value){
                new Future.delayed(const Duration(milliseconds: 750), () => widget.afterSave());
                
              })
              : service.addCostumer(costumer).then((value){
                new Future.delayed(const Duration(milliseconds: 750), () => widget.afterSave());
              });
  }

  void onDelete() => showDialog(
      context: context,
      builder: (context) =>
        DeleteDialog(onDelete:(){
          service.removeCostumer(widget.id).then((value){
                new Future.delayed(const Duration(milliseconds: 750), () => widget.afterDelete());
              });
        })
  );

  void getCostumer(){
    setState(() => status = LoadStatus.loading);
    service.getById(widget.id).then((cost) => setState(() {
            costumer = cost;
            // codeController.text = product.code;
            nameController.text = costumer.name;
            // priceController.text = product.price.toString();
            // minController.text = product.min.toString();
            // unityController.text = product.unity.index.toString();
            status = LoadStatus.loaded;
          }));
  }

  InputDecoration decorateField(String label, IconData icon) =>
      InputDecoration(labelText: label, suffixIcon: Icon(icon));

  @override
  void initState() {
    if (hasID()) getCostumer();
    super.initState();
  }

    @override
  void didUpdateWidget(CostumerFormComponent oldWidget){
    if (hasID()) getCostumer();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    service.setContext(context);
    return AsyncComponent(
      data: {'widget': 1},
      status: status,
      child: Form(
        child: ListView(
          padding: EdgeInsets.all(30),
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(children: [
                Text("Informações básicas",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    textAlign: TextAlign.left),
                SizedBox(height: 20)
              ]),
              TextFormField(
                  autofocus: true,
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: decorateField("Nome do cliente", Icons.person),
                  maxLines: 1),
              SizedBox(height: 20),
            ]),
            SizedBox(height: 40),
            Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              "Endereço",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 30,
              child: Column(
                children: [
                  TextFormField(
                    controller: codeController,
                      keyboardType: TextInputType.number,
                      decoration: decorateField("CEP", Icons.code),
                      maxLines: 1),
                  
                ],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 70,
              child: TextFormField(
                  controller: streetController,
                  keyboardType: TextInputType.streetAddress,
                  decoration:
                      decorateField("Endereço", Icons.map),
                  maxLines: 1),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 40,
              child: Column(
                children: [
                  TextFormField(
                    controller: numberController,
                      keyboardType: TextInputType.streetAddress,
                      decoration: decorateField("Número", Icons.code),
                      maxLines: 1),
                ],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 60,
              child: TextFormField(
                  controller: complementController,
                  keyboardType: TextInputType.streetAddress,
                  decoration:
                      decorateField("Complemento", Icons.control_point),
                  maxLines: 1),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex:100,
              child: TextFormField(
                  controller: referenceController,
                  keyboardType: TextInputType.streetAddress,
                  decoration:
                      decorateField("Referência", Icons.business),
                  maxLines: 1),
            ),
          ],
        ),
      ],
    ),
            SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(
                      "Contato",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 20,
                      child: TextFormField(
                          controller: dddController,
                          keyboardType: TextInputType.number,
                          decoration: decorateField("DDD", Icons.call_made),
                          maxLines: 1),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 80,
                      child: TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: decorateField("Telefone", Icons.phone),
                          maxLines: 1),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
            SizedBox(height: 40),
            Row(
      children: [
        ElevatedButton.icon(
          onPressed: onSave,
          icon: Icon(Icons.save),
          label: Text(hasID() ? "Atualizar" : "Salvar"),
        ),
        SizedBox(width: 20),
        if (hasID())
          ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.red[700]),
            ),
            onPressed: onDelete,
            icon: Icon(Icons.delete),
            label: Text("Excluir"),
          ),
      ],
    ),
          ],
        ),
      ),
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