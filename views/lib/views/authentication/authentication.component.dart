import 'package:comies/services/authentication.service.dart';
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
    AuthenticationService service = new AuthenticationService(context);
    service
        .login(
            nickname: operatorController.text,
            password: passwordController.text)
        .then((response) =>
            response.success ? Navigator.pushNamed(context, '/') : null);
  }

  void register() {}

  TextFormField passwordField() {
    return TextFormField(
      controller: passwordController,
      keyboardType: TextInputType.text,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: "Senha",
        suffix: IconButton(
          icon: Icon(Icons.visibility_off_rounded),
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
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Apelido",
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
                height: 30,
              ),
              ElevatedButton.icon(
                  icon: Icon(Icons.login),
                  onPressed: operatorController.text.trim() != "" &&
                          passwordController.text.trim() != ""
                      ? buttonAction(true)
                      : null,
                  label: Text('Entrar'))
            ],
          ),
        ),
      ),
    );
  }
}
