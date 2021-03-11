import 'package:comies/controllers/authentication.controller.dart';
import 'package:comies/controllers/main.controller.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart' show themeSwitcher;

class ComiesDrawer extends StatefulWidget {
  @override
  DrawerState createState() => DrawerState();
}

class DrawerState extends State<ComiesDrawer> {
  ThemeMode themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Ajustes"),
            onTap: () {
              Navigator.pushNamed(context, "/settings");
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Ajuda"),
            onTap: () {
              Navigator.pushNamed(context, "/help");
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Sair"),
            onTap: () {
              AuthenticationController.logoff().then((v) {
                Navigator.pushNamed(context, "/authentication");
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.phonelink_setup),
            title: Text("Reajustar"),
            onTap: () => Navigator.pushNamed(context, "/welcome"),
          ),
          ListTile(
            leading: Icon(Icons.food_bank),
            title: Text("Cozinha"),
            onTap: () => Navigator.pushNamed(context, "/panel"),
          ),
          Divider(thickness: 1.2),
          SwitchListTile(
            title: Text('Modo noturno'),
            activeColor: Theme.of(context).accentColor,
            value:
                Theme.of(context).brightness == Brightness.light ? false : true,
            onChanged: (switcher) => switcher
                ? themeSwitcher(ThemeMode.dark)
                : themeSwitcher(ThemeMode.light),
          )
        ],
      );
  }
}

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> menuEntries = [
    {'name': 'Início', 'path': '/', 'icon': Icons.home, "clicked": true},
    {'name': 'Pedidos', 'path': '/orders', 'icon': Icons.post_add, "clicked": false},
    {'name': 'Produtos', 'path': '/products', 'icon': Icons.category, "clicked": false},
    {'name': 'Clientes', 'path': '/costumers', 'icon': Icons.people, "clicked": false},
  ];


  bool showTab = false;
  AnimationController _animationController;
  PersistentBottomSheetController sheetController;


  @override
  void initState(){
    _animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
              height: 50,
              width: MediaQuery.of(context).size.width * 0.7,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Hero(
                    tag: "menudrawer",
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        height: 45, width: 60,
                        child:
                          Center(child: 
                            IconButton(
                              icon: AnimatedIcon(icon: AnimatedIcons.menu_close, progress: _animationController),
                              onPressed: (){
                                sheetController != null ? _animationController.reverse() : _animationController.forward();
                                setState(() {
                                  if (sheetController != null){
                                    sheetController.close();
                                    if (sheetController != null) sheetController = null;
                                  } else sheetController = Scaffold.of(context).showBottomSheet((context) => ComiesDrawer());
                                  
                                });
                              }
                            )
                          ),
                        )
                    )
                  ),
                  for (var route in menuEntries)
                  Hero(
                    tag: "route "+route['name'],
                    child: Material(
                      color: Colors.transparent,
                      child: MenuButton(
                        text: route["name"], icon: route['icon'],
                        isClicked: Provider.of<SessionController>(context, listen: false).actualRoute == route["path"],
                        route: route['path'],
                        onClick: (route) => setState(() {Provider.of<SessionController>(context, listen: false).setActualRoute(route, context);}),
                      )
                    )
                  ),
                ],
              )
            ),
          ],
        ),
      );
  }
}

class MenuButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final String route;
  final bool isClicked;
  final Function(String) onClick;

  MenuButton({this.text, this.icon, this.route, this.isClicked, this.onClick});
  @override
  Widget build(BuildContext context) {
    bool isBigScreen() => MediaQuery.of(context).size.width > widthDivisor;

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 1000),
      reverseDuration: Duration(milliseconds: 1000),
      switchInCurve: Curves.easeInBack,
      switchOutCurve: Curves.easeOutBack,
      transitionBuilder: (child, animation) => SizeTransition(
          child: child, sizeFactor: animation, axis: Axis.horizontal),
      child: isBigScreen() 
        ? isClicked
          ? Container(
              width: 120,
              height: 45,
              child: TextButton.icon(
                  onPressed: () => null,
                  icon: Icon(icon),
                  label: Text(text.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(
                          TextStyle(color: Colors.white)))),
              key: ValueKey(route+"1"))
          : Container(
              height: 45,
              width: 100,
              child:
                  Center(child: IconButton(icon: Icon(icon), onPressed: () => onClick(route))),
              key: ValueKey(route+"2"))
        : Container(
              height: 45,
              width: 60,
              child:
                  Center(child: IconButton(icon: Icon(icon, color: isClicked ? Theme.of(context).brightness == Brightness.light ? Theme.of(context).primaryColor : Theme.of(context).accentColor : Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white), onPressed: isClicked ? () => null : () => onClick(route))),
              key: ValueKey(route+"2"+isClicked.toString()))
    );
  }
}
