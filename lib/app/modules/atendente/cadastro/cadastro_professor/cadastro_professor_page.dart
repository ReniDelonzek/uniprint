import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uniprint/app/shared/models/Usuario.dart';
import 'package:uniprint/app/shared/temas/Tema.dart';
import 'package:uniprint/app/shared/widgets/select_widget.dart';

class CadastroProfessorPage extends StatefulWidget {
  final String title;
  const CadastroProfessorPage({Key key, this.title = "CadastroProfessor"})
      : super(key: key);

  @override
  _CadastroProfessorPageState createState() => _CadastroProfessorPageState();
}

class _CadastroProfessorPageState extends State<CadastroProfessorPage> {
  Usuario user;
  ProgressDialog dialog;
  List<Map> list = List();

  @override
  Future<void> initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return new MaterialApp(
        color: Colors.white,
        theme: Tema.getTema(buildContext),
        home: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Cadastrar professor'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                // var item =
                //     await Navigator.of(buildContext).push(new MaterialPageRoute(
                //         builder: (BuildContext context) => new ListaTurnos(
                //               tipoSelecao: 1,
                //             )));
                // setState(() {
                //   list.add(item);
                // });
              },
              tooltip: 'Adicionar disciplina',
              child: Icon(Icons.add),
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
                        // var user = await Navigator.of(context).push(
                        //     new MaterialPageRoute(
                        //         builder: (BuildContext context) =>
                        //             new SelecionarUsuario()));
                        // setState(() {
                        //   this.user = user;
                        // });
                      }),
                      Expanded(
                        child: ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (BuildContext ctxt, int index) =>
                                _getItemList(list[index])),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new ButtonTheme(
                            height: 45,
                            minWidth: 120,
                            child: RaisedButton(
                              onPressed: () async {
                                if (verificarDados(context)) {
                                  dialog = ProgressDialog(context,
                                      type: ProgressDialogType.Normal,
                                      isDismissible: false,
                                      showLogs: true);
                                  for (Map item in list) {
                                    await Firestore.instance
                                        .collection('Turnos')
                                        .document(item['turno'])
                                        .collection('Disciplinas')
                                        .document(item['disciplina'])
                                        .collection('Peridos')
                                        .document(item['periodo'])
                                        .collection('Professores')
                                        .document(user.id)
                                        .setData({
                                      'nome': user.nome,
                                      'codUsu': user.id,
                                      'dataAdicao': DateTime.now(),
                                    });
                                  }
                                  Navigator.pop(buildContext);
                                  /*
                                  .then((res) {
                                      dialog.dismiss();
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text('Cadastrado com sucesso'),
                                        duration: Duration(seconds: 3),
                                      ));
                                    }).catchError((error) {
                                      dialog.dismiss();
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text('Cadastrado com sucesso'),
                                        duration: Duration(seconds: 3),
                                      ));
                                    })
                                   */

                                }
                              },
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.5),
                              ),
                              child: new Text(
                                'SALVAR',
                                style: new TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              );
            })));
  }

  Widget _getItemList(Map map) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Turno: ${map['nomeTurno']}'),
            Text('Disciplina: ${map['nomeDisciplina']}'),
            Text('Periodo: ${map['nomePeriodo']}'),
          ],
        ),
      ),
    );
  }

  bool verificarDados(BuildContext context) {
    if (user == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Você precisa selecionar o usuário'),
          duration: Duration(seconds: 3)));
    } else
      return true;
  }
}
