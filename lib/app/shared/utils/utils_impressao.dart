import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uniprint/app/shared/db/hive/utils_hive_service.dart';
import 'package:uniprint/app/shared/db/valor_impressao.dart';
import 'package:uniprint/app/shared/models/graph/arquivo_impressao.dart';
import 'package:uniprint/app/shared/network/graph_ql_data.dart';
import 'package:uniprint/app/shared/network/mutations.dart';
import 'package:uniprint/app/shared/extensions/date.dart';

import '../../app_module.dart';
import 'constans.dart';

class UtilsImpressao {
  static String getStatusImpressao(int status) {
    switch (status) {
      case Constants.STATUS_IMPRESSAO_SOLICITADO:
        return "Impressão solicitada";
      case Constants.STATUS_IMPRESSAO_AUTORIZADO:
        return "Impressão Autorizada";
      case Constants.STATUS_IMPRESSAO_AGUARDANDO_RETIRADA:
        return "Suas folhas estão aguardando retirada";
      case Constants.STATUS_IMPRESSAO_RETIRADA:
        return "Impressão finalizada";
      case Constants.STATUS_IMPRESSAO_CANCELADO:
        return "Impressão cancelada";
      case Constants.STATUS_IMPRESSAO_NEGADA:
        return "Impressão negada";

      default:
        return '';
    }
  }

  static String getTipoMovimentacao(int tipo) {
    switch (tipo) {
      case Constants.MOV_IMPRESSAO_SOLICITADO:
        return "Impressão solicitada";
      case Constants.MOV_IMPRESSAO_AGUARDANDO_RETIRADA:
        return "Suas folhas estão aguardando retirada";
      case Constants.MOV_IMPRESSAO_AUTORIZADO:
        return "Impressão autorizada";
      case Constants.MOV_IMPRESSAO_NEGADA:
        return "Impressão negada";
      case Constants.MOV_IMPRESSAO_CANCELADO:
        return "Impressão cancelada";
      case Constants.MOV_IMPRESSAO_RETIRADA:
        return "Impressão finalizada";
      default:
        return '';
    }
  }

  static IconData getIconeFromStatus(int status) {
    switch (status) {
      case Constants.STATUS_IMPRESSAO_SOLICITADO:
        return Icons.star;
      case Constants.STATUS_IMPRESSAO_AUTORIZADO:
        return Icons.done;
      case Constants.STATUS_IMPRESSAO_AGUARDANDO_RETIRADA:
        return Icons.local_printshop;
      case Constants.STATUS_IMPRESSAO_RETIRADA:
        return Icons.done_all;
      case Constants.STATUS_IMPRESSAO_CANCELADO:
        return Icons.close;
      case Constants.STATUS_IMPRESSAO_NEGADA:
        return Icons.error_outline;
      default:
        return Icons.star;
    }
  }

  static String getResumo(List<ArquivoImpressao> arquivos) {
    String s = "${arquivos.length}";
    if (arquivos.length <= 1) {
      s += " arquivo\n";
    } else
      s += " arquivos\n";
    List<ArquivoImpressao> a3 =
        arquivos.where((item) => item.tipoFolha.id == 2).toList();
    List<ArquivoImpressao> a4 =
        arquivos.where((item) => item.tipoFolha.id == 1).toList();
    if (a3.isNotEmpty) {
      int sum = 0;
      a3.forEach((ArquivoImpressao e) {
        sum += e.quantidade * (e.num_paginas ?? 1);
      });
      s += "$sum folha${sum > 1 ? 's' : ''} do tipo A3";
      List<ArquivoImpressao> color =
          a3.where((item) => item.colorido == true).toList();
      if (color.isNotEmpty) {
        int sumColoridas = 0;
        color.forEach((ArquivoImpressao e) {
          sumColoridas += e.quantidade * (e.num_paginas ?? 1);
        });
        if (sumColoridas == sum) {
          if (sum == 1) {
            s += ", colorida\n";
          } else {
            s += ", todas coloridas\n";
          }
        } else {
          s +=
              ", $sumColoridas coloridas e ${sum - sumColoridas} em preto e branco\n";
        }
      } else {
        s += "\n";
      }
    }
    if (a4.isNotEmpty) {
      int sum = 0;
      a4.forEach((ArquivoImpressao e) {
        sum += e.quantidade * (e.num_paginas ?? 1);
      });
      s += "$sum folha${sum > 1 ? 's' : ''} do tipo A4";
      List<ArquivoImpressao> color =
          a4.where((item) => item.colorido == true).toList();
      if (color.isNotEmpty) {
        int sumColoridas = 0;
        color.forEach((ArquivoImpressao e) {
          sumColoridas += e.quantidade * (e.num_paginas ?? 1);
        });
        if (sumColoridas == sum) {
          if (sum == 1) {
            s += ", colorida\n";
          } else {
            s += ", todas coloridas\n";
          }
        } else {
          s +=
              ", $sumColoridas coloridas e ${sum - sumColoridas} em preto e branco\n";
        }
      } else {
        s += "\n";
      }
    }
    return s.substring(0, s.lastIndexOf('\n'));
  }

  static int getQuantidadeFolhasArq(
      List<ArquivoImpressao> arquivos, String tipo, bool colorido) {
    List<ArquivoImpressao> ar = arquivos
        .where(
            (item) => item.tipoFolha.nome == tipo && item.colorido == colorido)
        .toList();
    int qtdF = 0;
    for (ArquivoImpressao a in ar) {
      qtdF += (a.quantidade * (a.num_paginas ?? 1)).toInt();
    }
    return qtdF;
  }

  static Future<double> getValorImpressaoArquivos(
      List<ArquivoImpressao> arquivos) async {
    int qtdA3C = getQuantidadeFolhasArq(arquivos, "A3", true);
    int qtdA3 = getQuantidadeFolhasArq(arquivos, "A3", false);
    int qtdA4C = getQuantidadeFolhasArq(arquivos, "A4", true);
    int qtdA4 = getQuantidadeFolhasArq(arquivos, "A4", false);

    double valorA3 = await (getValorImpressaoTipo("A3", qtdA3, false));
    double valorA4 = await (getValorImpressaoTipo("A4", qtdA4, false));
    double valorA4C = await (getValorImpressaoTipo("A4", qtdA4C, true));
    double valorA3C = await (getValorImpressaoTipo("A3", qtdA3C, true));
    return valorA3 + valorA4 + valorA3C + valorA4C;
  }

  static Future<double> getValorImpressaoTipo(
      String tipo, int quantidade, bool colorido) async {
    Box box = await AppModule.to
        .getDependency<UtilsHiveService>()
        .getBox('precificacao');
    var valores = box.values.cast<ValorImpressao>();
    ;
    if (valores != null && valores.isNotEmpty) {
      var val = valores.firstWhere(
          (element) => (element.tipo_folha_id == tipo &&
              element.data_inicio.isBefore(DateTime.now()) &&
              element.data_fim.isAfter(DateTime.now())), orElse: () {
        return null;
      });
      if (val != null) {
        return val.valor * quantidade;
      }
    }
    return 0.25 * quantidade;
  }

  static Future<bool> gerarMovimentacao(int tipo, int status, int impressaoId,
      int usuario, BuildContext context, String message) async {
    ProgressDialog progressDialog = ProgressDialog(context)
      ..style(message: message)
      ..show();
    try {
      var res = await GraphQlObject.hasuraConnect
          .mutation(Mutations.cadastroMovimentacaoImpressao, variables: {
        'data': DateTime.now().hasuraFormat(),
        'tipo': tipo,
        'impressao_id': impressaoId,
        'status': status,
        'usuario_id': usuario
      });
      progressDialog.dismiss();
      return res != null;
    } catch (e) {
      print(e);
      progressDialog.dismiss();
      return false;
    }
  }
}

cadastrarValoresImpressao() {
  /*Map<String, dynamic> map = Map();
    map['valor'] = 1.0;
    map['tipoFolha'] = "A4";
    map['dataInicio'] = DateTime.now().millisecondsSinceEpoch;
    map['dataFim'] = 0;
    map['colorido'] = false;
    base.database.insert("ValorImpressao", map);

    Map<String, dynamic> map2 = Map();
    map2['valor'] = 2.0;
    map2['tipoFolha'] = "A3";
    map2['dataInicio'] = DateTime.now().millisecondsSinceEpoch;
    map2['dataFim'] = 0;
    map2['colorido'] = false;
    base.database.insert("ValorImpressao", map2);

    Map<String, dynamic> map3 = Map();
    map3['valor'] = 1.5;
    map3['tipoFolha'] = "A4";
    map3['dataInicio'] = DateTime.now().millisecondsSinceEpoch;
    map3['dataFim'] = 0;
    map3['colorido'] = true;
    base.database.insert("ValorImpressao", map3);

    Map<String, dynamic> map4 = Map();
    map4['valor'] = 2.5;
    map4['tipoFolha'] = "A3";
    map4['dataInicio'] = DateTime.now().millisecondsSinceEpoch;
    map4['dataFim'] = 0;
    map4['colorido'] = true;
    base.database.insert("ValorImpressao", map4);*/
}
