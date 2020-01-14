import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:uniprint/app/shared/models/arquivo_impressao.dart';

part 'cadastro_arquivos_impressao_controller.g.dart';

class CadastroArquivosImpressaoController = _CadastroArquivosImpressaoBase
    with _$CadastroArquivosImpressaoController;

abstract class _CadastroArquivosImpressaoBase with Store {
  @observable
  PageController pageController = PageController();

  List<ArquivoImpressao> arquivos = List();
//nao anotar com observable, o desempenho é melhor
  double currentPageValue = 0.0;
}
