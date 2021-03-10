import 'package:comies/controllers/authentication.controller.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:flutter/material.dart';

class AuthenticationComponent extends StatefulWidget {
  final bool canGo;

  AuthenticationComponent({Key key, this.canGo}) : super(key: key);

  @override
  Authentication createState() => Authentication();
}

class Authentication extends State<AuthenticationComponent> {
  TextEditingController operatorController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool obscureText = true;
  bool passwordFocus = false;
  bool stayConnected = false;

  dynamic buttonAction(bool isLogin) {
    if (isLogin) {
      if (widget.canGo != null) {
        if (widget.canGo) {
          return login;
        } else
          return null;
      }
      return login;
    } else {
      return null;
    }
  }

  void login() {
    FocusScope.of(context).unfocus();
    new AuthenticationController()
        .login(
            nickname: operatorController.text,
            password: passwordController.text,
            stayConnected: stayConnected)
        .then((response) =>
            response.success ? Navigator.pushNamed(context, '/') : null);
  }

  TextFormField passwordField() {
    return TextFormField(
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      onChanged: (c) => setState((){}),
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: "Senha",
        suffixIcon: IconButton(
          icon: Icon( obscureText ? Icons.visibility_rounded : Icons.visibility_off_rounded),
          onPressed: () => setState(() {
            obscureText = !obscureText;
          }),
        ),
      ),
      maxLines: 1,
    );
  }

  TextFormField operatorNameField() {
    return TextFormField(
      controller: operatorController,
      autofocus: true,
      keyboardType: TextInputType.name,
      onChanged: (c) => setState((){}),
      decoration: InputDecoration(
        labelText: "Usuário",
        suffixIcon: Icon(Icons.person),
      ),
      maxLines: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        child: Container(
          width: MediaQuery.of(context).size.width > widthDivisor ? 400 : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              operatorNameField(),
              const SizedBox(
                height: 30,
              ),
              passwordField(),
              const SizedBox(
                height: 30
              ),
              Center(
                child: Row(
                children: [
                  Checkbox(value: stayConnected, onChanged: (value) => setState((){stayConnected = value;}), activeColor: Theme.of(context).accentColor),
                  SizedBox(width: 20),
                  Text("Me mantenha conectado(a)"),
                ],
              ),
              ),
              SizedBox(
                height: 30
              ),
              TextButton(
                  onPressed: operatorController.text.trim() != "" &&
                          passwordController.text.trim() != ""
                      ? login
                      : null,
                  child: Text('ENTRAR'))
            ],
          ),
        ),
      ),
    );
  }
}
