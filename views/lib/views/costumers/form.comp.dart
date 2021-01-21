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
  final TextEditingController country;

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
            // DetailedInformationForm(
            //   minController: widget.minController,
            //   unityController: widget.unityController,
            //   onDropdownChange: onDropdownChange,
            //   isUpdate: widget.isUpdate,
            // ),
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
            Divider(
              thickness: 1.2,
              height: 20.2,
            ),
          ],
        ),
        TextFormField(
            controller: nameController,
            keyboardType: TextInputType.name,
            decoration: decorateField("Nome do cliente", Icons.person),
            maxLines: 1),
        SizedBox(height: 20),
      ],
    );
  }
}

// class AddressForm extends StatelessWidget {
//   final TextEditingController name;
//   final TextEditingController code;
//   final TextEditingController street;
//   final TextEditingController number;
//   final TextEditingController district;
//   final TextEditingController city;
//   final TextEditingController state;
//   final TextEditingController country;

//   AddressForm(
//       {
//             this.code,
//     this.street,
//     this.number,
//     this.district,
//     this.city,
//     this.state,
//     this.country,
//       });

//   InputDecoration decorateField(String label, IconData icon) {
//     return InputDecoration(
//       labelText: label,
//       suffixIcon: Icon(icon),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Column(
//           children: [
//             Text(
//               "Endereço",
//               style: TextStyle(
//                 color: Theme.of(context).primaryColor,
//               ),
//               textAlign: TextAlign.left,
//             ),
//             Divider(
//               thickness: 1.2,
//               height: 20.2,
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             Expanded(
//               flex: 30,
//               child: Column(
//                 children: [
//                   SizedBox(height: 17),
//                   DropdownButton(
//                     isExpanded: true,
//                     value: unityController.text == ""
//                         ? null
//                         : int.parse(unityController.text),
//                     onChanged: onDropdownChange,
//                     items: [
//                       DropdownMenuItem(
//                         child: Text("Quilogramas"),
//                         value: 0,
//                       ),
//                       DropdownMenuItem(
//                         child: Text("Miligramas"),
//                         value: 1,
//                       ),
//                       DropdownMenuItem(
//                         child: Text("Litros"),
//                         value: 2,
//                       ),
//                       DropdownMenuItem(
//                         child: Text("Mililitros"),
//                         value: 3,
//                       ),
//                       DropdownMenuItem(
//                         child: Text("Unidade"),
//                         value: 4,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: 10),
//             Expanded(
//               flex: 70,
//               child: TextFormField(
//                   controller: minController,
//                   keyboardType: TextInputType.number,
//                   decoration:
//                       decorateField("Quantidade mínima", Icons.shopping_cart),
//                   maxLines: 1),
//             ),
//           ],
//         ),
//         SizedBox(height: 20),
//       ],
//     );
//   }
// }

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
        if (onDelete != null)
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
