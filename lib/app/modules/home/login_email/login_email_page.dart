import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uniprint/app/app_module.dart';
import 'package:uniprint/app/modules/home/home_module.dart';
import 'package:uniprint/app/modules/home/splash_screen/splash_module.dart';
import 'package:uniprint/app/shared/auth/hasura_auth_service.dart';
import 'package:uniprint/app/shared/temas/tema.dart';
import 'package:uniprint/app/shared/utils/utils_cadastro.dart';
import 'package:uniprint/app/shared/utils/utils_sentry.dart';

import 'login_email_controller.dart';

class LoginEmailPage extends StatefulWidget {
  final String title;
  const LoginEmailPage({Key key, this.title = "LoginEmail"}) : super(key: key);

  @override
  _LoginEmailPageState createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  final _controller = SplashModule.to.bloc<LoginEmailController>();

  @override
  void initState() {
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
            height: 340,
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
                          hintText: 'Insira seu e-mail',
                          labelText: 'Insira seu e-mail'),
                      controller: _controller.controllerEmail,
                    ),
                    Observer(
                      builder: (_) => TextFormField(
                        obscureText: !_controller.exibirSenha,
                        decoration: InputDecoration(
                          labelText: 'Insira sua senha',
                          hintText: 'Insira sua senha',
                          suffixIcon: new GestureDetector(
                            onTap: () {
                              _controller.exibirSenha =
                                  !_controller.exibirSenha;
                            },
                            child: new Icon(
                              _controller.exibirSenha
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        controller: _controller.controllerSenha,
                      ),
                    ),
                    // new Padding(padding: EdgeInsets.only(top: 8)),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: InkWell(
                    //     child: Text(
                    //       'Esqueci minha senha',
                    //       style: TextStyle(color: Colors.cyan),
                    //     ),
                    //     onTap: () {
                    //       if (validarEmail(
                    //           _controller.controllerEmail.text.trim())) {
                    //         _alterarSenha(context);
                    //       } else {
                    //         showSnack(context, 'Por favor, insira seu email');
                    //       }
                    //     },
                    //   ),
                    // ),
                    new Padding(padding: EdgeInsets.all(8)),
                    new ButtonTheme(
                      minWidth: 150,
                      child: new RaisedButton(
                          onPressed: () async {
                            //if (await DataConnectionChecker().hasConnection) {
                            String msg = verificarDados();
                            if (msg == null) {
                              logar(context); //criarConta(context);
                            } else {
                              showSnack(context, msg);
                            }
                            // } else {
                            //   showSnack(context,
                            //       'Ops, parece que você está sem conexão!');
                            // }
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: getCorPadrao(),
                          child: new Text(
                            "Entrar",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: FlatButton(
                        child: Text('Criar Conta'),
                        onPressed: () {
                          String msg = verificarDados();
                          if (msg == null) {
                            criarConta(context);
                          } else {
                            showSnack(context, msg);
                          }
                        },
                      ),
                    ),
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

  String verificarDados() {
    if (!validarEmail(_controller.controllerEmail.text.trim())) {
      return "Por favor, insira um email válido";
    } else if (_controller.controllerSenha.text.trim().length < 6) {
      return "A senha deve ter no mínimo 6 caracteres";
    }
    return null;
  }

  void logar(BuildContext context) {
    ProgressDialog progressDialog = ProgressDialog(context)
      ..style(message: 'Autenticando')
      ..show();
    try {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _controller.controllerEmail.text.trim(),
              password: _controller.controllerSenha.text.trim())
          .then((user) {
        if (user == null) {
          progressDialog.dismiss();
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text("Ops, houve uma falha ao realizar o login"),
          ));
        } else {
          AppModule.to
              .getDependency<HasuraAuthService>()
              .obterDadosUsuario(user.user.uid, (usuario) {
            progressDialog.dismiss();
            if (usuario != null) {
              Route route =
                  MaterialPageRoute(builder: (context) => HomeModule());
              Navigator?.pushReplacement(context, route);
            } else {
              Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text("Ops, houve uma falha ao realizar o login"),
              ));
            }
          });
        }
      }).catchError((error, stackTrace) {
        UtilsSentry.reportError(error, stackTrace);
        progressDialog.dismiss();
        if (error is PlatformException) {
          if (error.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text(
                  "Ops, parece que você já acessou de alguma outra forma com esse e-mail"),
            ));
          } else if (error.code == "ERROR_WRONG_PASSWORD") {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("Ops, parece que a sua senha está incorreta"),
            ));
          } else if (error.code == "ERROR_INVALID_EMAIL") {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("Ops, o e-mail inserido é inválido"),
            ));
          } else if (error.code == "ERROR_USER_NOT_FOUND") {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("Ops, houve uma falha na tentativa de login"),
            ));
          } else if (error.code == "ERROR_USER_DISABLED") {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("Ops, parece que seu usuário foi desabilitado"),
            ));
          } else if (error.code == "ERROR_TOO_MANY_REQUESTS") {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text(
                  "Ops, parece que você já tentou entrar diversas vezes com essa conta com as credenciais inválidas"),
            ));
          } else if (error.code == "ERROR_OPERATION_NOT_ALLOWED") {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("Ops, parece que sua conta não está ativa"),
            ));
          }
        } else {
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text("Ops, houve uma falha na tentativa de login"),
          ));
        }
      });
    } catch (error, stackTrace) {
      UtilsSentry.reportError(error, stackTrace);
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Ops, houve uma falha na tentativa de login"),
      ));
    }
  }

  Future criarConta(BuildContext buildContext) async {
    ProgressDialog progressDialog = ProgressDialog(context)
      ..style(message: 'Criando Conta')
      ..show();
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _controller.controllerEmail.text.trim(),
            password: _controller.controllerSenha.text.trim())
        .then((user) {
      if (user == null) {
        progressDialog.dismiss();
        Scaffold.of(buildContext).showSnackBar(new SnackBar(
          content:
              new Text("Ops, houve uma falha ao realizar ao criar a conta"),
        ));
      } else {
        AppModule.to
            .getDependency<HasuraAuthService>()
            .obterDadosUsuario(user.user.uid, (value) async {
          if (value != null) {
            progressDialog.dismiss();
            Navigator.of(context)?.pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) => new HomeModule()));
          }
        });
      }
    }).catchError((error, stackTrace) {
      UtilsSentry.reportError(error, stackTrace);
      progressDialog.dismiss();
      showSnack(buildContext,
          'Ops, houve uma falha ao criar a conta, você já não tem uma conta com esse email?',
          duration: Duration(seconds: 5));
      /*if ((error as PlatformException).code == 'ERROR_WEAK_PASSWORD') {
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
        */ /*Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Ops, o e-mail inserido já está em uso"),
        ));*/ /*
      } else {}*/
    });
  }
}
