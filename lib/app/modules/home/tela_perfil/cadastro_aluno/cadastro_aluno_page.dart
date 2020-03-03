import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uniprint/app/modules/home/home_module.dart';
import 'package:uniprint/app/shared/widgets/button.dart';

import 'cadastro_aluno_controller.dart';

class CadastroAlunoPage extends StatefulWidget {
  final String title;
  const CadastroAlunoPage({Key key, this.title = "Cadastrar Aluno"})
      : super(key: key);

  @override
  _CadastroAlunoPageState createState() => _CadastroAlunoPageState();
}

class _CadastroAlunoPageState extends State<CadastroAlunoPage> {
  final controller = HomeModule.to.bloc<CadastroAlunoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Center(
              child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Como é o seu RA?'),
                controller: controller.ctlRA,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'E a sua senha?'),
                controller: controller.ctlSenha,
              ),
              Button("Validar", () {})
            ],
          )),
        ),
      ),
    );
  }
}
