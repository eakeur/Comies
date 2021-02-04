import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/views/costumers/form.comp.dart';
import 'package:flutter/material.dart';

class DetailedScreen extends StatefulWidget {
  final int id;

  DetailedScreen({this.id});

  @override
  Detailed createState() => Detailed();
}

class Detailed extends State<DetailedScreen> {

  bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
  bool hasID() => widget.id != null && widget.id != 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            //The top bar app
            appBar: AppBar(
              title: Text(hasID() ? 'Detalhes' : 'Adicionar'),
              elevation: 8
            ),

            //The body of the app
            body: CostumerFormComponent(id:widget.id, afterDelete:(){Navigator.pop(context);}, afterSave: (){Navigator.pop(context);})
          );
  }
}

