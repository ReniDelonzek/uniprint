import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:uniprint/app/shared/models/graph/turno.dart';

part 'cadastro_aluno_controller.g.dart';

class CadastroAlunoController = _CadastroAlunoBase
    with _$CadastroAlunoController;

abstract class _CadastroAlunoBase with Store {
  @observable
  Turno turno;
  final TextEditingController ctlRA = TextEditingController();
  final TextEditingController ctlSenha = TextEditingController();
  
}
