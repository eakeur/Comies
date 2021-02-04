import 'dart:io';

import 'package:comies/utils/declarations/menu.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  final MenuEntries menu;
  HomeScreen({Key key, this.menu}) : super(key: key); 

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
    return Scaffold(
      drawer: widget.menu.drawer(context),
      appBar: appBar(),
      body: Center(),
    );
  }
}
