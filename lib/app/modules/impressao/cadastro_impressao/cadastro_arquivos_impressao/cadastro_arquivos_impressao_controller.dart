import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:uniprint/app/shared/extensions/string.dart';
import 'package:uniprint/app/shared/models/graph/arquivo_impressao.dart';
import 'package:uniprint/app/shared/widgets/selecionar_quantidade/selecionar_quantidade_controller.dart';

part 'cadastro_arquivos_impressao_controller.g.dart';

class CadastroArquivosImpressaoController = _CadastroArquivosImpressaoBase
    with _$CadastroArquivosImpressaoController;

abstract class _CadastroArquivosImpressaoBase with Store {
  @observable
  PageController pageController = PageController();
  SelecionarQuantidadeController ctlQuantidade =
      SelecionarQuantidadeController();

  List<ArquivoImpressao> arquivos = List();
//nao anotar com observable, o desempenho é melhor
  @observable
  double currentPageValue = 0.0;
  @observable
  Icon icon = Icon(Icons.navigate_next);

  Future<bool> obterNumeroPaginas() async {
    for (ArquivoImpressao arquivoImpressao in arquivos) {
      if (!arquivoImpressao.path.isNullOrEmpty()) {
        File file = File(arquivoImpressao.path);
        if (File(file.resolveSymbolicLinksSync()).lengthSync() <= 50000000) {
          //50 mb
          PdfDocument pdf = await PdfDocument.openFile(arquivoImpressao.path);
          arquivoImpressao.num_paginas = pdf.pageCount;
          await pdf.dispose();
        } else {
          arquivoImpressao.num_paginas = 0;
        }
      }
    }
    return true;
  }
}
