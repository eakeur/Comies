import 'package:comies/components/button.component.dart';
import 'package:comies/controllers/main.controller.dart';
import 'package:comies/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MainController(),
      child: Comies()
    )
  );
}

class Comies extends StatelessWidget {
  
  Route onGeneratedRoute(RouteSettings route){
    switch (route.name) {
      case "/": return PageRouteBuilder(pageBuilder: (context, anim1, anim2) => Column(
        children: [TextButton(
        text: "Clique para mudar a cor", onTap: () => print("clicked"),
      ), TextButton(
        text: "Clique para mudar a cor", onTap: () => print("clicked"),
      ), TextButton(
        text: "Clique para mudar a cor", onTap: () => print("clicked"),
      )],
      ));
      default: return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<MainController>(
      builder: (context, data, child){
        return WidgetsApp(
          title: 'Comies',
          onGenerateRoute: onGeneratedRoute,
          color: data.mainColor,
        );
      },
    );
  }
}