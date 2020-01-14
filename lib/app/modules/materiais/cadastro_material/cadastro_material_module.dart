import 'package:uniprint/app/modules/materiais/cadastro_material/cadastro_material_controller.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:uniprint/app/modules/materiais/cadastro_material/cadastro_material_page.dart';

class CadastroMaterialModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => CadastroMaterialController()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => CadastroMaterialPage();

  static Inject get to => Inject<CadastroMaterialModule>.of();
}
