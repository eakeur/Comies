import 'package:comies/components/async.comp.dart';
import 'package:comies/services/costumers.service.dart';
import 'package:comies/services/products.service.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';

class CostumerFormComponent extends StatefulWidget {
  final CostumersService service;
  final LoadStatus status;
  final Function onSave;
  final Function onDelete;
  final bool isUpdate;
  final TextEditingController name;
  final TextEditingController code;
  final TextEditingController street;
  final TextEditingController number;
  final TextEditingController district;
  final TextEditingController city;
  final TextEditingController state;
  final TextEditingController complement;
  final TextEditingController reference;
  final TextEditingController country;
  final TextEditingController ddd;
  final TextEditingController phone;

  CostumerFormComponent({
    Key key,
    this.status,
    this.service,
    this.onSave,
    this.onDelete,
    this.isUpdate,
    this.name,
    this.code,
    this.street,
    this.number,
    this.district,
    this.city,
    this.state,
    this.country,
    this.complement,
    this.reference,
    this.ddd,
    this.phone,
  }) : super(key: key);

  @override
  CostumerForm createState() => CostumerForm();
}

class CostumerForm extends State<CostumerFormComponent> {
  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;

  void onDelete() {
    showDialog(
        context: context,
        builder: (context) {
          return DeleteDialog(onDelete: widget.onDelete);
        });
  }

  void onSave() {
    if (widget.isUpdate) {
      showDialog(
          context: context,
          builder: (context) {
            return UpdateDialog(onUpdate: widget.onSave);
          });
    } else {
      widget.onSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    //Text forms declarations before rendering anything
    widget.service.setContext(context);
    return AsyncComponent(
      data: {'widget': 1},
      status: widget.status,
      child: Form(
        child: ListView(
          padding: EdgeInsets.all(30),
          children: [
            BasicInformationForm(
              nameController: widget.name,
              isUpdate: widget.isUpdate,
            ),
            SizedBox(height: 40),
            AddressForm(
              code: widget.code, street: widget.street, number: widget.number,
              district: widget.district, city: widget.city, state: widget.state, country: widget.country,
              reference: widget.reference, complement: widget.complement,
            ),
            SizedBox(height: 40),
            PhoneForm(ddd: widget.ddd, phone: widget.phone, isUpdate: widget.isUpdate),
            SizedBox(height: 40),
            ActionsForm(
              onSave: onSave,
              isUpdate: widget.isUpdate,
              onDelete: onDelete,
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

class UpdateDialog extends StatelessWidget {
  final Function onUpdate;
  final Function onCancel;

  UpdateDialog({this.onUpdate, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Deseja mesmo atualizar este produto?"),
      actions: [
        TextButton(
            onPressed: () {
              if (onCancel != null) onCancel();
              Navigator.pop(context);
            },
            child: Text("Cancelar")),
        TextButton(
          onPressed: () {
            onUpdate();
            Navigator.pop(context);
          },
          child: Text("Atualizar", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

class BasicInformationForm extends StatelessWidget {
  final TextEditingController nameController;
  final bool isUpdate;

  BasicInformationForm({this.nameController, this.isUpdate});

  InputDecoration decorateField(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      suffixIcon: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              "Informações básicas",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20),
          ],
        ),
        TextFormField(
            autofocus: true,
            controller: nameController,
            keyboardType: TextInputType.name,
            decoration: decorateField("Nome do cliente", Icons.person),
            maxLines: 1),
        SizedBox(height: 20),
      ],
    );
  }
}

class PhoneForm extends StatelessWidget {
  final TextEditingController phone;
  final TextEditingController ddd;
  final bool isUpdate;

  PhoneForm({this.phone, this.ddd, this.isUpdate});

  InputDecoration decorateField(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      suffixIcon: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              child:TextFormField(
              controller: ddd,
              keyboardType: TextInputType.number,
              decoration: decorateField("DDD", Icons.call_made),
              maxLines: 1),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 80,
              child:TextFormField(
              controller: ddd,
              keyboardType: TextInputType.phone,
              decoration: decorateField("Telefone", Icons.phone),
              maxLines: 1),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class AddressForm extends StatelessWidget {
  final TextEditingController complement;
  final TextEditingController reference;
  final TextEditingController code;
  final TextEditingController street;
  final TextEditingController number;
  final TextEditingController district;
  final TextEditingController city;
  final TextEditingController state;
  final TextEditingController country;

  AddressForm(
    {
      this.code,
      this.street,
      this.number,
      this.district,
      this.city,
      this.state,
      this.country,
      this.complement,
      this.reference,
    });

  InputDecoration decorateField(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      suffixIcon: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    controller: code,
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
                  controller: street,
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
                    controller: code,
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
                  controller: street,
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
                  controller: street,
                  keyboardType: TextInputType.streetAddress,
                  decoration:
                      decorateField("Referência", Icons.business),
                  maxLines: 1),
            ),
          ],
        ),
      ],
    );
  }
}

class ActionsForm extends StatelessWidget {
  final Function onSave;
  final Function onDelete;
  final bool isUpdate;

  ActionsForm({
    this.onDelete,
    this.onSave,
    this.isUpdate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: onSave,
          icon: Icon(Icons.save),
          label: Text(isUpdate ? "Atualizar" : "Salvar"),
        ),
        SizedBox(width: 20),
        if (isUpdate)
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
    );
  }
}
