import 'package:comies/components/menu.comp.dart';
import 'package:comies/main.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  @override
  Home createState() => Home();
}

class Home extends State<HomeScreen> {
  

  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text('Início'),
      elevation: 8,
    );
  }


  @override
  Widget build(BuildContext context) {
    return session.isAuthenticated() ? Scaffold(
      drawer: ComiesDrawer(),
      appBar: appBar(),
      body: Center(),
    ) : session.goToAuthenticationScreen();
  }
}
