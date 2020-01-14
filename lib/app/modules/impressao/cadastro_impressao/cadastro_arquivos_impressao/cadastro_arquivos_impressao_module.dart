import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:uniprint/app/shared/models/arquivo_impressao.dart';

import 'cadastro_arquivos_impressao_controller.dart';
import 'cadastro_arquivos_impressao_page.dart';

class CadastroArquivosImpressaoModule extends ModuleWidget {
  final List<ArquivoImpressao> arquivos;

  CadastroArquivosImpressaoModule(this.arquivos);
  @override
  List<Bloc> get blocs => [
        Bloc((i) => CadastroArquivosImpressaoController()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => CadastroArquivosImpressaoPage(
        arquivos: arquivos,
      );

  static Inject get to => Inject<CadastroArquivosImpressaoModule>.of();
}
