import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uniprint/app/shared/models/LocalAtendimento.dart';
import 'package:uniprint/app/shared/models/Usuario.dart';
import 'package:uniprint/app/shared/network/graph_ql_data.dart';
import 'package:uniprint/app/shared/network/mutations.dart';
import 'package:uniprint/app/shared/utils/utils_cadastro.dart';
import 'package:uniprint/app/shared/widgets/select_widget.dart';
import 'package:uniprint/app/shared/widgets/widgets.dart';

class CadastroAtendentePage extends StatefulWidget {
  final String title;
  const CadastroAtendentePage({Key key, this.title = "CadastroAtendente"})
      : super(key: key);

  @override
  _CadastroAtendentePageState createState() => _CadastroAtendentePageState();
}

class _CadastroAtendentePageState extends State<CadastroAtendentePage> {
  Usuario user;
  LocalAtendimento local;
  ProgressDialog dialog;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Cadastro operador'),
        ),
        body: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: new Container(
              child: Column(
                children: <Widget>[
                  SelectWidget(
                      'Selecione um usuário', user?.nome ?? user?.email,
                      () async {
                    // Usuario user = await Navigator.of(context).push(
                    //     new MaterialPageRoute(
                    //         builder: (BuildContext context) =>
                    //             new SelecionarUsuario()));
                    // if (user != null) {
                    //   setState(() {
                    //     this.user = user;
                    //   });
                    // }
                  }),
                  LocaisAtendimento('Ponto de atendimento', (local) {
                    setState(() {
                      this.local = local;
                    });
                  }, local: local),
                  new Padding(padding: EdgeInsets.only(top: 25)),
                  ButtonTheme(
                      height: 45,
                      minWidth: 220,
                      child: RaisedButton(
                        onPressed: () {
                          if (verificarDados(context)) {
                            // runMutation({
                            //   'usuario_id': user.id,
                            //   'ponto_atendimento_id': local.id
                            // });
                          }
                        },
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.5),
                        ),
                        child: new Text(
                          'SALVAR',
                          style: new TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )),
                ],
              ),
            ),
          );
        }));
  }

  bool verificarDados(BuildContext context) {
    if (user == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Você precisa selecionar o usuário'),
          duration: Duration(seconds: 3)));
      return false;
    } else if (local == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Você precisa selecionar o usuário'),
        duration: Duration(seconds: 3),
      ));
      return false;
    } else
      return true;
  }
}
