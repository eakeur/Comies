import 'package:comies/components/async.comp.dart';
import 'package:comies/services/costumers.service.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/utils/validators.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';

class CostumerFormComponent extends StatefulWidget {
  final bool readonly;
  final Function(Address) onSelectedAddress;
  final Function afterSave;
  final Function afterDelete;
  final int id;

  CostumerFormComponent({Key key, this.id, this.afterSave, this.afterDelete, this.readonly = false, this.onSelectedAddress})
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

  int orderAddress = 0;
  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
  bool hasID() => widget.id != null && widget.id != 0;
  bool hasPhones() =>
      costumer.phones != null &&
      costumer.phones.isNotEmpty;
  bool hasAddresses() =>
      costumer.addresses != null &&
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
    if (hasID()) service.updateCostumer(costumer).then((value) => getCostumer());
    else setState(() {});
    onPhoneClean();
  }

  void onPhoneClean() {
    dddController.text = '';
    phoneController.text = '';
  }

  void onPhoneRemove(Phone phone){
    if (phone.id != null){
      service.removeCostumerPhone(phone.id)
      .then((value) => setState((){costumer.phones.removeAt(costumer.phones.indexOf(phone));}));
    } else {
      setState((){costumer.phones.removeAt(costumer.phones.indexOf(phone));});
    }
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
    if (hasID()) service.updateCostumer(costumer).then((value) => getCostumer());
    else setState(() {});
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

  void onAddressRemove(Address addr){
    if (addr.id != null){
      service.removeCostumerAddress(addr.id)
      .then((value) => setState((){costumer.addresses.removeAt(costumer.addresses.indexOf(addr));}));
    } else {
      setState((){costumer.addresses.removeAt(costumer.addresses.indexOf(addr));});
      
    }
  }

  void getCostumer({setLoading = false}) {
    if (setLoading) setState(() => status = LoadStatus.loading);
    service.getById(widget.id).then((cost) => setState(() {
          costumer = cost;
          nameController.text = costumer.name;
          status = LoadStatus.loaded;
          if (widget.readonly && costumer.addresses.length == 1){
            orderAddress = costumer.addresses[0].id;
            widget.onSelectedAddress(costumer.addresses[0]);
          }
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
    if (hasID()) getCostumer(setLoading: true);
    super.initState();
  }

  @override
  void didUpdateWidget(CostumerFormComponent oldWidget) {
    if (hasID()) getCostumer(setLoading: true);
    super.didUpdateWidget(oldWidget);
  }

  List<Widget> form() {
    return [
      if (!hasID()) Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
      ]),
      SizedBox(height: 60),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                "Adicionar endereço",
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
                flex: 40,
                child: Column(
                  children: [
                    TextFormField(
                        controller: codeController,
                        keyboardType: TextInputType.number,
                        onChanged: onCEPChange,
                        decoration: decorateField("CEP", Icons.code),
                        maxLines: 1),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 60,
                child: TextFormField(
                    controller: streetController,
                    keyboardType: TextInputType.streetAddress,
                    decoration: decorateField("Endereço", Icons.map),
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
                flex: 50,
                child: TextFormField(
                    controller: referenceController,
                    keyboardType: TextInputType.streetAddress,
                    decoration: decorateField("Referência", Icons.business),
                    maxLines: 1),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 50,
                child: TextFormField(
                    controller: districtController,
                    keyboardType: TextInputType.streetAddress,
                    decoration: decorateField(
                        "Bairro", Icons.person_pin_circle_outlined),
                    maxLines: 1),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                  onPressed: onAddressSave,
                  icon: Icon(Icons.save),
                  tooltip: "Adicionar endereço"),
              SizedBox(width: 20),
              IconButton(
                onPressed: onAddressClean,
                icon: Icon(Icons.close),
                tooltip: "Limpar campos",
              ),
            ],
          )
        ],
      ),
      SizedBox(height: 60),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                "Adicionar telefones",
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
                flex: 40,
                child: TextFormField(
                    controller: dddController,
                    keyboardType: TextInputType.number,
                    decoration: decorateField("DDD", Icons.call_made),
                    maxLines: 1),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 60,
                child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: decorateField("Telefone", Icons.phone),
                    maxLines: 1),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                  onPressed: onPhoneSave,
                  icon: Icon(Icons.save),
                  tooltip: "Adicionar telefone"),
              SizedBox(width: 20),
              IconButton(
                onPressed: onPhoneClean,
                icon: Icon(Icons.close),
                tooltip: "Limpar campos",
              ),
            ],
          )
        ],
      ),
      SizedBox(height: 60),
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
      SizedBox(height: 60)
    ];
  }

  List<Widget> details() {
    return [
      if (hasID()) Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(children: [
          Text("Informações básicas",
              style: TextStyle(color: Theme.of(context).primaryColor),
              textAlign: TextAlign.left),
          SizedBox(height: 20)
        ]),
        TextFormField(
            autofocus: true,
            readOnly: widget.readonly,
            controller: nameController,
            keyboardType: TextInputType.name,
            decoration: decorateField("Nome do cliente", Icons.person),
            maxLines: 1),
      ]),
      if (hasID() || hasPhones()) SizedBox(height: 60),
      if (hasID() || hasPhones())
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  "Telefones",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 20),
              ],
            ),
            if (hasPhones())
              Column(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: hasPhones() ? [
                    for (var phone in costumer.phones)
                      ListTile(
                          title: Text("(${phone.ddd}) ${phone.number}"),
                          leading: Icon(Icons.phone),
                          trailing: IconButton(onPressed:() => onPhoneRemove(phone), icon: Icon(Icons.delete), tooltip:"Excluir telefone"),
                        ),
                  ] : [],
                ).toList(),
              )
            else
              Center(
                  child: Text(
                      'Este cliente não informou nenhum telefone ou celular ainda.')),
          ],
        ),
      if (hasID() || hasAddresses()) SizedBox(height: 60),
      if (hasID() || hasAddresses())
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  "Endereços",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 20),
              ],
            ),
            if (hasAddresses())
              Column(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: hasAddresses() ? [
                    for (var addr in costumer.addresses)
                      ListTile(
                          title: Text(
                              "${addr.street}, ${addr.number} - ${addr.district}",
                              softWrap: true),
                          subtitle: Text(
                              "${addr.city} - ${addr.state} - ${addr.reference}",
                              softWrap: true),
                          trailing: IconButton(onPressed: () => onAddressRemove(addr), icon: Icon(Icons.delete), tooltip:"Excluir endereço"),
                          leading: !widget.readonly ? Icon(Icons.map) : Checkbox(activeColor: Theme.of(context).accentColor, value: addr.id == orderAddress, onChanged: (b){ setState((){orderAddress = addr.id;}); widget.onSelectedAddress(addr);})
                          ),
                  ] : [],
                ).toList(),
              )
            else
              Center(
                  child:
                      Text('Este cliente não informou nenhum endereço ainda.')),
          ],
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    service.setContext(context);
    var widgets = hasID() ? details() : form();
    hasID() ? widgets.addAll(form()) : widgets.addAll(details());
    return AsyncComponent(
      data: {'widget': 1},
      status: status,
      child: Form(
        child: ListView(
          padding: EdgeInsets.all(30),
          children: widgets
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
