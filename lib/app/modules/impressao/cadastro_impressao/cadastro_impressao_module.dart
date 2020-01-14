import 'package:uniprint/app/modules/impressao/cadastro_impressao/cadastro_impressao_controller.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:uniprint/app/modules/impressao/cadastro_impressao/cadastro_impressao_page.dart';

class CadastroImpressaoModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => CadastroImpressaoController()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => CadastroImpressaoPage();

  static Inject get to => Inject<CadastroImpressaoModule>.of();
}
