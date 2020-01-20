import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:uniprint/app/shared/utils/utils_login.dart';

import '../home_module.dart';
import 'login_email_controller.dart';

class LoginEmailPage extends StatefulWidget {
  final String title;
  const LoginEmailPage({Key key, this.title = "LoginEmail"}) : super(key: key);

  @override
  _LoginEmailPageState createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  final controllerEmail = TextEditingController();
  final controllerSenha = TextEditingController();
  final controller = HomeModule.to.bloc<LoginEmailController>();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  void initState() {
    controllerEmail.addListener(() {});
    controllerSenha.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Builder(
      builder: (context) => new Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('imagens/back_login.jpg'), fit: BoxFit.cover),
        ),
        child: new SizedBox(
            height: 280,
            width: 300,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration( 
                          labelText: 'Insira seu e-mail'),
                      controller: controllerEmail,
                    ),
                    Observer(
                      builder: (_) => TextFormField(
                        obscureText: controller.obscure,
                        decoration: InputDecoration( 
                            hintText: 'Escolha uma senha'),
                        controller: controllerSenha,
                      ),
                    ),
                    new Padding(padding: EdgeInsets.all(15)),
                    new ButtonTheme(
                      minWidth: 150,
                      child: new RaisedButton(
                          onPressed: () {
                            if (verificarDados(context)) {
                              criarConta(context);
                            }
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: Colors.blue,
                          child: new Text(
                            "Entrar",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    new Padding(padding: EdgeInsets.all(5)),
                    new Text(
                      "Esqueceu a senha?",
                      style: new TextStyle(color: Colors.blue),
                    )
                  ],
                ),
              ),
            )),
      ),
    ));
  }

  bool validarEmail(String email) {
    String regex =
        "[a-z0-9!#\$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    RegExp regExp = new RegExp(regex);
    return regExp.hasMatch(email);
  }

  bool verificarDados(BuildContext context) {
    if (!validarEmail(controllerEmail.text)) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Por favor, insira um email válido"),
      ));
      return false;
    } else if (controllerSenha.text.length < 6) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("A senha deve ter no mínimo 6 caracteres"),
      ));
      return false;
    }
    return true;
  }

  logar(BuildContext context) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: controllerEmail.text, password: controllerSenha.text)
        .then((user) {
      if (user == null) {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Ops, houve uma falha ao realizar o login"),
        ));
      } else {
        posLogin(user, context);
      }
    }).catchError((error) {
      if ((error as PlatformException).code ==
          'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text(
              "Ops, parece que você já acessou com suas redes sociais com esse e-mail"),
        ));
      } else if ((error as PlatformException).code == "ERROR_WRONG_PASSWORD") {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Ops, parece que a sua senha está incorreta"),
        ));
      } else if ((error as PlatformException).code == "ERROR_INVALID_EMAIL") {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Ops, o e-mail inserido é inválido"),
        ));
      } else if ((error as PlatformException).code == "ERROR_USER_NOT_FOUND") {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Ops, houve uma falha na tentativa de login"),
        ));
      } else if ((error as PlatformException).code == "ERROR_USER_DISABLED") {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Ops, parece que seu usuário foi desabilitado"),
        ));
      } else if ((error as PlatformException).code ==
          "ERROR_TOO_MANY_REQUESTS") {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text(
              "Ops, parece que você já tentou entrar diversas vezes com essa conta com as credenciais inválidas, tente novamente mais tarde"),
        ));
      } else if ((error as PlatformException).code ==
          "ERROR_OPERATION_NOT_ALLOWED") {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Ops, parece que sua conta não está ativa"),
        ));
      }
    });
  }

  Future criarConta(BuildContext context) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: controllerEmail.text, password: controllerSenha.text)
        .then((user) {
      if (user == null) {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Ops, houve uma falha ao realizar o login"),
        ));
      } else {
        posLogin(user, context);
      }
    }).catchError((error) {
      if ((error as PlatformException).code == 'ERROR_WEAK_PASSWORD') {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Ops, parece que a sua senha está incorreta"),
        ));
      } else if ((error as PlatformException).code == "ERROR_INVALID_EMAIL") {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Ops, o e-mail inserido é inválido"),
        ));
      } else if ((error as PlatformException).code ==
          "ERROR_EMAIL_ALREADY_IN_USE") {
        logar(context);
        /*Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Ops, o e-mail inserido já está em uso"),
        ));*/
      } else {}
    });
  }
}
