import 'package:comies/components/menu.comp.dart';
import 'package:comies/components/screen.comp.dart';
import 'package:comies/controllers/costumer.controller.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/views/costumers/form.comp.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailedCostumerScreen extends StatefulWidget {
  final Costumer costumer;
  final bool isAddition;

  DetailedCostumerScreen({this.costumer, this.isAddition = false});

  @override
  Detailed createState() => Detailed();
}

class Detailed extends State<DetailedCostumerScreen> {

  bool get isBigScreen => MediaQuery.of(context).size.width > widthDivisor;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CostumerController(costumer: widget.costumer),
      child: Scaffold(

        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: NavigationBar(),
        appBar: AppBar(title: Text("Detalhes")),

        body: Screen(
          onRefresh: () => new Future(() => setState(() {})),
          children: [CostumerFormComponent(isAddition: widget.isAddition)]
        )
      ),
    );
  }
}

