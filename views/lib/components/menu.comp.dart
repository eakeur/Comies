import 'package:comies/services/authentication.service.dart';
import 'package:flutter/material.dart';
import '../main.dart' show session, themeSwitcher;

class ComiesDrawer extends StatefulWidget {
  @override
  DrawerState createState() => DrawerState();
}

class DrawerState extends State<ComiesDrawer> {
  ThemeMode themeMode = ThemeMode.system;

  List<Map<String, dynamic>> menuEntries = [
    {'name': 'Início', 'path': '/', 'icon': Icons.home},
    {'name': 'Pedidos', 'path': '/orders', 'icon': Icons.post_add},
    {'name': 'Produtos', 'path': '/products', 'icon': Icons.category},
    {'name': 'Clientes', 'path': '/costumers', 'icon': Icons.people},
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person, size:24),
                  title: Text(session.operator.name),
                  subtitle: Text("Perfil: " + session.permissions.name),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          for (var screen in menuEntries)
            ListTile(
              leading: Icon(screen['icon']),
              title: Text(screen['name']),
              onTap: () {
                Navigator.pushNamed(context, screen['path']);
              },
            ),
            Divider(thickness: 1.2),
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
                new AuthenticationService(null).logoff()
                .then((v) {Navigator.pushNamed(context, "/authentication");});
              },
              
            ),
            ListTile(
              leading: Icon(Icons.phonelink_setup),
              title: Text("Reajustar"),
              onTap: () => Navigator.pushNamed(context, "/welcome"),
              
            ),
            Divider(thickness: 1.2),
            SwitchListTile(
              title: Text('Modo noturno'),
              activeColor: Theme.of(context).accentColor,
              value: Theme.of(context).brightness == Brightness.light ? false : true,
              onChanged: (switcher) => switcher ? themeSwitcher(ThemeMode.dark) : themeSwitcher(ThemeMode.light),
            ),
        ],
      ),
    );
  }
}