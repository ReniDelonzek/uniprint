import 'package:uniprint/app/modules/atendimento/cadastro_atendimento/cadastro_atendimento_controller.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:uniprint/app/modules/atendimento/cadastro_atendimento/cadastro_atendimento_page.dart';

class CadastroAtendimentoModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => CadastroAtendimentoController()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => CadastroAtendimentoPage();

  static Inject get to => Inject<CadastroAtendimentoModule>.of();
}
