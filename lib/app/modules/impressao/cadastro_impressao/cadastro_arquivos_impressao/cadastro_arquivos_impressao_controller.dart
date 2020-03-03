import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:uniprint/app/shared/models/graph/arquivo_impressao.dart';
import 'package:uniprint/app/shared/extensions/string.dart';

part 'cadastro_arquivos_impressao_controller.g.dart';

class CadastroArquivosImpressaoController = _CadastroArquivosImpressaoBase
    with _$CadastroArquivosImpressaoController;

abstract class _CadastroArquivosImpressaoBase with Store {
  @observable
  PageController pageController = PageController();

  List<ArquivoImpressao> arquivos = List();
//nao anotar com observable, o desempenho é melhor
  double currentPageValue = 0.0;

  Future<bool> obterNumeroPaginas() async {
    for (ArquivoImpressao arquivoImpressao in arquivos) {
      if (!arquivoImpressao.patch.isNullOrEmpty()) {
        PdfDocument pdf = await PdfDocument.openFile(arquivoImpressao.patch);
        arquivoImpressao.num_paginas = pdf.pageCount;
        await pdf.dispose();
      }
    }
    return true;
  }
}
