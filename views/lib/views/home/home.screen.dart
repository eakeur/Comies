import 'package:comies/components/menu.comp.dart';
import 'package:comies/main.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  @override
  Home createState() => Home();
}

class Home extends State<HomeScreen> {
  
  
  @override
  Widget build(BuildContext context) {
    return session.isAuthenticated ? Scaffold(
      bottomNavigationBar: NavigationBar(),
      body: Hero(tag:"home", child: Text("Hello")), 
    ): session.goToAuthenticationScreen();
  }
}
