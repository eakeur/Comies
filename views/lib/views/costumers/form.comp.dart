import 'package:comies/components/async.comp.dart';
import 'package:comies/components/responsebar.comp.dart';
import 'package:comies/components/textfield.comp.dart';
import 'package:comies/components/titlebox.comp.dart';
import 'package:comies/controllers/costumer.controller.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/utils/declarations/themes.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CostumerFormComponent extends StatefulWidget {
  final bool isAddition;
  final Function(Address) onAddressTap;
  final Function(Phone) onPhoneTap;


  CostumerFormComponent({this.isAddition= false, this.onAddressTap, this.onPhoneTap});

  @override
  CostumerForm createState() => CostumerForm();
}

class CostumerForm extends State<CostumerFormComponent> {

  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;

  void onSave() => Provider.of<CostumerController>(context, listen: false).addCostumer()
    .then((value) => ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value)))
    .catchError((value) => ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value, action: onSave)));

  void onDelete() => showDialog(context: context, builder: (ctx) => DeleteDialog(
    onDelete:() => Provider.of<CostumerController>(context, listen: false).removeCostumer()
    .then((value){ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value));if (!isBigScreen()) Navigator.pop(context);})
    .catchError((value) => ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value, action: onDelete)))));

  void onUpdate() => Provider.of<CostumerController>(context, listen: false).updateCostumer()
    .then((value) => ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value)))
    .catchError((value) => ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value, action: onUpdate)));

  @override
  Widget build(BuildContext context) {
    return Consumer<CostumerController>(
      builder: (context, data, child){
        return AsyncComponent(
          data: widget.isAddition ? {widget: "new"} : data.costumer,
          status: data.addPending != false || data.deletePending != false ? LoadStatus.loaded : data.costumerLoadStatus,
          messageIfNullOrEmpty: "Selecione um cliente para ver seus detalhes",
          child: widget.isAddition || data.costumer != null
            ? ListView(
              padding: EdgeInsets.all(30),
              children: [
                NameFormComponent(costumer: data.costumer), 
                if (!widget.isAddition) 
                AddressDetailsComponent(onSelected: widget.onAddressTap, addresses: data.costumer.addresses, loadStatus: data.addressesLoadStatus),
                if (!widget.isAddition) 
                PhoneDetailsComponent(phones: data.costumer.phones, loadStatus: data.phonesLoadStatus), 
                AddressFormComponent(address: data.address), 
                PhoneFormComponent(phone: data.phone),
                if (widget.isAddition && data.costumer.addresses != null && data.costumer.addresses.isNotEmpty) 
                AddressDetailsComponent(onSelected: widget.onAddressTap, addresses: data.costumer.addresses, loadStatus: data.addressLoadStatus), 
                if (widget.isAddition && data.costumer.phones != null && data.costumer.phones.isNotEmpty) 
                PhoneDetailsComponent(phones: data.costumer.phones, loadStatus: data.phonesLoadStatus), 
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!widget.isAddition)
                    AsyncButton(icon: Icon(Icons.delete), text: "EXCLUIR", style: dangerButton, onPressed: onDelete, isLoading: data.deletePending),
                    SizedBox(width: 20),
                    AsyncButton(icon: Icon(Icons.save), text: "SALVAR", style: successButton, 
                    onPressed: widget.isAddition ? onSave : onUpdate, 
                    isLoading: data.addPending),
                ])
              ]
            )
            : Center()
        );
      },
    );
  }
}

class AddressDetailsComponent extends StatelessWidget {

  final Function(Address) onSelected;
  final List<Address> addresses;
  final LoadStatus loadStatus;

  AddressDetailsComponent({this.onSelected, this.addresses, this.loadStatus});

  @override
  Widget build(BuildContext context) {
    return AsyncComponent(
      data: addresses,
      messageIfNullOrEmpty: "Este cliente não informou nenhum endereço ainda",
      status: loadStatus,
      child: Column(
        children: ListTile.divideTiles(
        context: context,
        tiles: [
          for (var addr in addresses)
            ListTile(
              title: Text("${addr.street}, ${addr.number} - ${addr.district}",softWrap: true),
              subtitle: Text("${addr.city} - ${addr.state} - ${addr.reference}",softWrap: true),
              leading: Icon(Icons.map),
              onTap: (){ if(onSelected != null)onSelected(addr); Provider.of<CostumerController>(context, listen: false).setAddress(addr);}
            ),
          ],
        ).toList(),
      )
    );
  }
}

class PhoneDetailsComponent extends StatelessWidget {

  final List<Phone> phones;
  final LoadStatus loadStatus;

  PhoneDetailsComponent({this.phones, this.loadStatus});

  @override
  Widget build(BuildContext context) {
    return AsyncComponent(
      data: phones,
      messageIfNullOrEmpty: "Este cliente não informou nenhum telefone ainda",
      status: loadStatus,
      child: Column(
        children: ListTile.divideTiles(
        context: context,
        tiles: [
          for (var phone in phones)
          ListTile(
            title: Text("(${phone.ddd}) ${phone.number}"),
            leading: Icon(Icons.phone),
            onTap: () => Provider.of<CostumerController>(context, listen: false).setPhone(phone)
            ),
          ],
        ).toList(),
      )
    );
  }
}

class AddressFormComponent extends StatelessWidget {

  final Address address;

  AddressFormComponent({this.address});

  @override
  Widget build(BuildContext context) {
    void onAddressSave() => Provider.of<CostumerController>(context, listen: false).addAddress()
      .then((value) => ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value)))
      .catchError((value) => ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value, action: onAddressSave)));
    void onAddressRemove() => Provider.of<CostumerController>(context, listen: false).removeAddress()
      .then((value) => ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value)))
      .catchError((value) => ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value, action: onAddressRemove)));
    void onAddressClean() => Provider.of<CostumerController>(context, listen: false).clearAddress();
    return Column(
          children: [
            FormGroup(
              title: TitleBox(" Adicionar Endereço"),
              build: {
                1:{
                  'spaces': [40, 60],
                  'fields':[
                    TextFieldComponent(
                      fieldName: 'CEP',
                      value: address.cep,
                      icon: Icon(Icons.code),
                      onFieldChange: (s){
                        address.cep = s;
                        if(s.length == 8) Provider.of<CostumerController>(context, listen: false).getAddressByCEP();
                      },
                      textInputType: TextInputType.number
                    ),
                    TextFieldComponent(
                      value: address.street,
                      fieldName: 'Endereço',
                      onFieldChange: (s) => address.street = s,
                      icon: Icon(Icons.map),
                    ),
                  ]
                },
                2:{
                  'spaces': [40, 60],
                  'fields':[
                    TextFieldComponent(
                      fieldName: 'Número',
                      value: address.number,
                      onFieldChange: (s) => address.number = s,
                      icon: Icon(Icons.point_of_sale),
                    ),
                    TextFieldComponent(
                      fieldName: 'Complemento',
                      value: address.complement,
                      onFieldChange: (s) => address.complement = s,
                      icon: Icon(Icons.control_point),
                    ),
                  ]
                }, 
                3:{
                  'spaces': [50, 50],
                  'fields':[
                    TextFieldComponent(
                      fieldName: 'Referência',
                      value: address.reference,
                      onFieldChange: (s) => address.reference = s,
                      icon: Icon(Icons.business),
                    ),
                    TextFieldComponent(
                      fieldName: 'Bairro',
                      value: address.district,
                      onFieldChange: (s) => address.district = s,
                      icon: Icon(Icons.person_pin_circle_outlined),
                    ),
                  ]
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AsyncButton(icon: Icon(Icons.delete), tooltip: "Excluir endereço", onPressed: onAddressRemove, style: dangerButton, isLoading: Provider.of<CostumerController>(context, listen: false).deleteAddressPending),
                SizedBox(width: 20),
                IconButton(onPressed: onAddressClean, icon: Icon(Icons.close),tooltip: "Limpar campos"),
                SizedBox(width: 20),
                AsyncButton(icon: Icon(Icons.save), tooltip: "Salvar endereço", onPressed: onAddressSave, style: successButton, isLoading: Provider.of<CostumerController>(context, listen: false).addAddressPending)
              ],
            ),
          ],
        );
  }
}

class PhoneFormComponent extends StatelessWidget {

  final Phone phone;
  PhoneFormComponent({this.phone});
  @override
  Widget build(BuildContext context) {
    void onPhoneSave() => Provider.of<CostumerController>(context, listen: false).addPhone()
      .then((value) => ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value)))
      .catchError((value) => ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value, action: onPhoneSave)));
    void onPhoneRemove() => Provider.of<CostumerController>(context, listen: false).removePhone()
      .then((value) => ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value)))
      .catchError((value) => ScaffoldMessenger.of(context).showSnackBar(ResponseBar(value, action: onPhoneRemove)));
    void onPhoneClean() => Provider.of<CostumerController>(context, listen: false).clearPhone();
    return Column(
      children: [
        FormGroup(
          title: TitleBox('Adicionar Contato'),
          build: {
            1:{
              'spaces': [40, 60],
              'fields':[
                TextFieldComponent(
                  icon: Icon(Icons.call_made),
                  fieldName:"DDD",
                  value: phone.ddd,
                  onFieldChange: (s) => phone.ddd = s,
                  textInputType: TextInputType.number,
                ),
                TextFieldComponent(
                  icon: Icon(Icons.phone),
                  value: phone.number,
                  onFieldChange: (s) => phone.number = s,
                  fieldName:"Número de telefone",
                  textInputType: TextInputType.number,
                ),
              ]
            }
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AsyncButton(icon: Icon(Icons.delete), tooltip: "Excluir telefone", onPressed: onPhoneRemove, style: dangerButton, isLoading: Provider.of<CostumerController>(context, listen: false).deletePhonePending),
            SizedBox(width: 20),
            IconButton(onPressed: onPhoneClean, icon: Icon(Icons.close),tooltip: "Limpar campos"),
            SizedBox(width: 20),
            AsyncButton(icon: Icon(Icons.save), tooltip: "Salvar telefone", onPressed: onPhoneSave, style: successButton, isLoading: Provider.of<CostumerController>(context, listen: false).addPhonePending)
          ],
        ),
      ],
    );
  }
}

class NameFormComponent extends StatelessWidget {
  final Costumer costumer;
  NameFormComponent({this.costumer});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormGroup(
          title: TitleBox('Informações básicas'),
          build: {
            1:{
              'spaces': [100,0],
              'fields':[
                TextFieldComponent(
                  icon: Icon(Icons.person),
                  fieldName:"Nome do cliente",
                  onFieldChange: (s) => costumer.name = s,
                  value: costumer.name,
                ),
              ]
            }
          },
        ),
      ],
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
      title: Text("Deseja mesmo excluir este item?"),
      content: Text("Esta ação não poderá ser desfeita."),
      actions: [
        TextButton(
            onPressed: () {
              if (onCancel != null) onCancel();
              Navigator.pop(context);
            },
            child: Text("Cancelar")),
        ElevatedButton(
          style: dangerButton,
          onPressed: () {
            onDelete();
            Navigator.pop(context);
          },
          child: Text("Excluir"),
        ),
      ],
    );
  }
}
