import 'package:comies/views/authentication/authentication.component.dart';
import 'package:flutter/material.dart';

class AuthenticationScreen extends StatefulWidget {

  @override
  Authentication createState() => Authentication();
}

class Authentication extends State<AuthenticationScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(16),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 90),
                  Text("Bem-vindo(a)!", textAlign: TextAlign.center, style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 48,
                  )),
                  SizedBox(height: 30),
                  Text("Insira seu nome de usuário e senha para acessar sua conta" , textAlign: TextAlign.center),
                  SizedBox(height: 30),
                  AuthenticationComponent(),
                ],
              )
            ),
          ),
        ),
      )
    );
  }
}
