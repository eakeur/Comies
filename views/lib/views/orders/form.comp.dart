import 'package:comies/components/async.comp.dart';
import 'package:comies/services/costumers.service.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/utils/validators.dart';
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
  bool hasPhones() =>
      costumer.phones != null &&
      costumer.phones is List &&
      costumer.phones.isNotEmpty;
  bool hasAddresses() =>
      costumer.addresses != null &&
      costumer.addresses is List &&
      costumer.addresses.isNotEmpty;

  void onCodeChange(int change) =>
      setState(() => codeController.text = change.toString());

  void onSave() {
    costumer.name = nameController.text;

    if (isTextValid(codeController.text) &&
        isTextValid(streetController.text)) {
      var address = new Address();
      address.cep = codeController.text;
      address.street = streetController.text;
      address.number = numberController.text;
      address.complement = complementController.text;
      address.reference = referenceController.text;
      address.district = districtController.text;
      address.city = cityController.text;
      address.state = stateController.text;
      address.country = countryController.text;
      costumer.addresses == null
          ? costumer.addresses = [address]
          : costumer.addresses.add(address);
    }

    if (isTextValid(dddController.text) && isTextValid(phoneController.text)) {
      var phone = new Phone();
      phone.ddd = codeController.text;
      phone.number = phoneController.text;
      costumer.phones == null
          ? costumer.phones = [phone]
          : costumer.phones.add(phone);
    }

    costumer.id = widget.id;
    hasID()
        ? service.updateCostumer(costumer).then((value) {
            new Future.delayed(
                const Duration(milliseconds: 750), () => widget.afterSave());
          })
        : service.addCostumer(costumer).then((value) {
            new Future.delayed(
                const Duration(milliseconds: 750), () => widget.afterSave());
          });
  }

  void onDelete() => showDialog(
      context: context,
      builder: (context) => DeleteDialog(onDelete: () {
            service.removeCostumer(widget.id).then((value) {
              new Future.delayed(const Duration(milliseconds: 750),
                  () => widget.afterDelete());
            });
          }));

  void onPhoneSave() {
    if (isTextValid(dddController.text) && isTextValid(phoneController.text)) {
      var phone = new Phone();
      phone.ddd = dddController.text;
      phone.number = phoneController.text;
      costumer.phones == null
          ? costumer.phones = [phone]
          : costumer.phones.add(phone);
    }
    if (hasID()) service.updateCostumer(costumer);
    setState(() {});
    onPhoneClean();
  }

  void onPhoneClean() {
    dddController.text = '';
    phoneController.text = '';
  }

  void onAddressSave() {
    if (isTextValid(codeController.text) &&
        isTextValid(streetController.text)) {
      var address = new Address();
      address.cep = codeController.text;
      address.street = streetController.text;
      address.number = numberController.text;
      address.complement = complementController.text;
      address.reference = referenceController.text;
      address.district = districtController.text;
      address.city = cityController.text;
      address.state = stateController.text;
      address.country = countryController.text;
      costumer.addresses == null
          ? costumer.addresses = [address]
          : costumer.addresses.add(address);
    }
    if (hasID()) service.updateCostumer(costumer);
    setState(() {});
    onAddressClean();
  }

  void onAddressClean() {
    codeController.text = '';
    streetController.text = '';
    numberController.text = '';
    districtController.text = '';
    complementController.text = '';
    referenceController.text = '';
    cityController.text = '';
    stateController.text = '';
    countryController.text = '';
  }


  void getCostumer() {
    setState(() => status = LoadStatus.loading);
    service.getById(widget.id).then((cost) => setState(() {
          costumer = cost;
          nameController.text = costumer.name;
          status = LoadStatus.loaded;
        }));
  }



  void onCEPChange(String change) {
    if (change.length == 8) {
      service.getAddressInfo(change).then((value) {
        if (value != null) {
          if (value['erro'] != null && value['erro'] == true) return;
          codeController.text = value['cep'];
          streetController.text = value['logradouro'];
          districtController.text = value['bairro'];
          cityController.text = value['localidade'];
          stateController.text = value['uf'];
          countryController.text = "Brasil";
          setState((){});
        }
      });
    }
  }

  InputDecoration decorateField(String label, IconData icon) =>
      InputDecoration(labelText: label, suffixIcon: Icon(icon));

  @override
  void initState() {
    if (hasID()) getCostumer();
    super.initState();
  }

  @override
  void didUpdateWidget(OrderFormComponent oldWidget) {
    if (hasID()) getCostumer();
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    service.setContext(context);
    return AsyncComponent(
      data: {'widget': 1},
      status: status,
      child: Stepper(
        steps: [
          Step(
            title: Text('Selecione ou adidione um cliente'),
           content: Form(
              child: TextButton(child: Text("hu"), onPressed: () => null),
            )
          ),
          Step(
            title: Text('Selecione ou adidione um cliente'),
            content: Form(
              child: TextButton(child: Text("hu"), onPressed: () => null),
            )
          ),
          Step(
            title: Text('Selecione ou adidione um cliente'),
            content: Form(
              child: TextButton(child: Text("hu"), onPressed: () => null),
            )
          ),
        ],
      )
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
