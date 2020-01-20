import 'package:uniprint/app/modules/materiais/lista_materiais/lista_materiais_controller.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:uniprint/app/modules/materiais/lista_materiais/lista_materiais_page.dart';

class ListaMateriaisModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => ListaMateriaisController()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => ListaMateriaisPage();

  static Inject get to => Inject<ListaMateriaisModule>.of();
}
