import 'package:comies/services/authentication.service.dart';
import 'package:flutter/material.dart';

class MenuEntries {

  Function(ThemeMode) themeSwitcher;

  ThemeMode mode;

  MenuEntries({this.themeSwitcher, this.mode});

  List<Map<String, dynamic>> menuEntries = [
    {'name': 'Início', 'path': '/', 'icon': Icons.home},
    {'name': 'Pedidos', 'path': '/orders', 'icon': Icons.post_add},
    {'name': 'Produtos', 'path': '/products', 'icon': Icons.category},
    {'name': 'Clientes', 'path': '/costumers', 'icon': Icons.people},
  ];

  Widget drawer(context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Comies'),
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
