import 'package:comies/components/menu.comp.dart';
import 'package:comies/components/screen.comp.dart';
import 'package:comies/controllers/costumer.controller.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/views/costumers/form.comp.dart';
import 'package:comies/views/costumers/list.comp.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';
import 'package:comies/views/costumers/edit.screen.dart';
import 'package:provider/provider.dart';

class CostumersScreen extends StatefulWidget {
  @override
  Costumers createState() => Costumers();
}

class Costumers extends State<CostumersScreen> {

  void navigateTo(Costumer costumer) => Navigator.push(context,
    MaterialPageRoute(builder: (BuildContext context) => DetailedCostumerScreen(costumer: costumer)));
  
  bool get isBigScreen => MediaQuery.of(context).size.width > widthDivisor;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CostumerController(),
      child: Scaffold(

        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: NavigationBar(),
        floatingActionButton: AddButton(),

        body: Screen(
          onRefresh: () => new Future(() => setState(() {})),
          children: [

            //BIG SCREEN RENDERING
             if (isBigScreen) Row(
              children: [ 
                Expanded(flex: 35,
                  child: Card( margin: EdgeInsets.all(0), elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                  child: CostumersListComponent())),
                Expanded(flex: 65, child: Center( child: Container(child: CostumerFormComponent())))
              ]
            )
            else //SMALL SCREEN RENDERING
            Container(child: CostumersListComponent(onListClick: navigateTo))
          ]
        )
      ),
    );
  }
}

class AddButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;
    return FloatingActionButton(
        onPressed: (){
          isBigScreen() ? 
            Scaffold.of(context).showBottomSheet((context) => 
              Container(height: MediaQuery.of(context).size.height - 100, child: DetailedCostumerScreen(costumer: new Costumer(), isAddition: true)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))
          : Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) => new DetailedCostumerScreen(costumer: new Costumer(), isAddition: true)));
        },
        tooltip: 'Adicionar cliente',
        child: Icon(Icons.add));
  }
}