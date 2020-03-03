import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uniprint/app/shared/auth/hasura_auth_service.dart';
import 'package:uniprint/app/shared/models/graph/ponto_atendimento.dart';
import 'package:uniprint/app/shared/network/graph_ql_data.dart';
import 'package:uniprint/app/shared/network/mutations.dart';
import 'package:uniprint/app/shared/utils/constans.dart';
import 'package:uniprint/app/shared/utils/utils_cadastro.dart';
import 'package:uniprint/app/shared/widgets/widgets.dart';
import '../../../app_module.dart';

class CadastroAtendimentoPage extends StatefulWidget {
  final String title;
  PontoAtendimento local;
  CadastroAtendimentoPage({Key key, this.title = "Cadastro Atendimento"})
      : super(key: key);

  @override
  _CadastroAtendimentoPageState createState() =>
      _CadastroAtendimentoPageState();
}

class _CadastroAtendimentoPageState extends State<CadastroAtendimentoPage> {
  List<PontoAtendimento> locais = List();
  final controllerObs = TextEditingController();
  ProgressDialog progressDialog;
  var selec = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Solicitar atendimento"),
        ),
        backgroundColor: Colors.white,
        body: Builder(
            builder: (context) => _getPageCadastroAtendimento(context)));
  }

  Widget _getPageCadastroAtendimento(BuildContext context) {
    Widget f = Container(
        width: 180,
        height: 180,
        child: new Container(
            width: 180,
            height: 180,
            child: FloatingActionButton(
                heroTag: 'add_atendimento',
                child: Image.asset(
                  'imagens/agendamento.png',
                  color: Colors.white,
                ),
                onPressed: () async {
                  if (verificarDados(context)) {
                    ProgressDialog progressDialog = ProgressDialog(context);
                    progressDialog.style(message: 'Cadastrando atendimento...');
                    progressDialog.show();
                    try {
                      var res = await GraphQlObject.hasuraConnect
                          .mutation(cadastroAtendimento, variables: {
                        'tipo': Constants.STATUS_ATENDIMENTO_SOLICITADO,
                        'usuario_id': AppModule.to
                            .getDependency<HasuraAuthService>()
                            .usuario
                            .codHasura,
                        'data': DateFormat('yyyy-MM-ddTHH:mm:ss')
                            .format(DateTime.now()),
                        'ponto_atendimento_id': widget.local.id,
                        'status': Constants.STATUS_ATENDIMENTO_SOLICITADO
                      });
                      if (res != null) {
                        progressDialog.dismiss();
                        showSnack(
                            context, 'Atendimento cadastrado com sucesso!',
                            dismiss: true);
                      }
                    } catch (e) {
                      progressDialog.dismiss();
                      showSnack(context,
                          'Ops, houve uma falha ao cadastrar o atendimento');
                    }
                  }
                })));
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        LocaisAtendimento(
          'Selecione o Local',
          (local) {
            setState(() {
              this.widget.local = local;
            });
          },
          local: widget.local,
        ),
        Expanded(
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              f,
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Text(
                  'Clique para agendar',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  bool verificarDados(BuildContext context) {
    if (widget.local == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Você precisa selecionar o local do atendimento'),
      ));
      return false;
    }
    return true;
  }
}
