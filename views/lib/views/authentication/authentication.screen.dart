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
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Theme.of(context).primaryColorDark,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Center(
              heightFactor: 2.5,
              child:AuthenticationComponent(),
            ),
          ),
        ),
      )
    );
  }
}
