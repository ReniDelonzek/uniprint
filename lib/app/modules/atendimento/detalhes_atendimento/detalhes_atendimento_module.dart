import 'package:uniprint/app/modules/atendimento/detalhes_atendimento/detalhes_atendimento_controller.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:uniprint/app/modules/atendimento/detalhes_atendimento/detalhes_atendimento_page.dart';
import 'package:uniprint/app/shared/models/graph/atendimento_g.dart';

class DetalhesAtendimentoModule extends ModuleWidget {
  final Atendimento atendimento;

  DetalhesAtendimentoModule(this.atendimento);
  @override
  List<Bloc> get blocs => [
        Bloc((i) => DetalhesAtendimentoController()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => DetalhesAtendimentoPage(atendimento);

  static Inject get to => Inject<DetalhesAtendimentoModule>.of();
}
