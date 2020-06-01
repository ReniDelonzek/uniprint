import 'package:uniprint/app/modules/impressao/detalhes_impressao/detalhes_impressao_controller.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:uniprint/app/modules/impressao/detalhes_impressao/detalhes_impressao_page.dart';
import 'package:uniprint/app/shared/models/graph/impressao.dart';

class DetalhesImpressaoModule extends ModuleWidget {
  final Impressao impressao;
  DetalhesImpressaoModule(this.impressao);

  @override
  List<Bloc> get blocs => [
        Bloc((i) => DetalhesImpressaoController()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => DetalhesImpressaoPage(this.impressao);

  static Inject get to => Inject<DetalhesImpressaoModule>.of();
}
