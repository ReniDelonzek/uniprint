import 'package:uniprint/app/shared/db/ValorImpressao.dart';
import 'package:uniprint/app/shared/db/app_database.dart';
import 'package:uniprint/app/shared/models/arquivo_impressao.dart';

class UtilsImpresao {
  static String getResumo(List<ArquivoImpressao> arquivos) {
    String s = "${arquivos.length} arquivos\n";
    List<ArquivoImpressao> a3 =
        arquivos.where((item) => item.tipo_folha_id == 'A3').toList();
    List<ArquivoImpressao> a4 =
        arquivos.where((item) => item.tipo_folha_id == 'A4').toList();
    if (a3.isNotEmpty) {
      int sum = 0;
      a3.forEach((ArquivoImpressao e) {
        sum += e.quantidade;
      });
      s += "$sum folhas do tipo A3";
      List<ArquivoImpressao> color =
          a3.where((item) => item.colorido == true).toList();
      if (color.isNotEmpty) {
        int sumColoridas = 0;
        color.forEach((ArquivoImpressao e) {
          sumColoridas += e.quantidade;
        });
        if (sumColoridas == sum) {
          s += ", todas coloridas\n";
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
        sum += e.quantidade;
      });
      s += "$sum folhas do tipo A4";
      List<ArquivoImpressao> color =
          a4.where((item) => item.colorido == true).toList();
      if (color.isNotEmpty) {
        int sumColoridas = 0;
        color.forEach((ArquivoImpressao e) {
          sumColoridas += e.quantidade;
        });
        if (sumColoridas == sum) {
          s += ", todas coloridas\n";
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
            (item) => item.tipo_folha_id == tipo && item.colorido == colorido)
        .toList();
    int qtdF = 0;
    for (ArquivoImpressao a in ar) {
      qtdF += a.quantidade;
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
    var base = await getDataBase();
    ValorImpressao valorImpressao = await base.valorImpressaoDao.getImpressao(
        tipo,
        DateTime.now().millisecondsSinceEpoch,
        DateTime.now().millisecondsSinceEpoch,
        colorido ? 1 : 0);
    return (valorImpressao?.valor ?? 0) * quantidade;
  }
}

cadastrarValoresImpressao() {
  getDataBase().then((base) {
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
  }).catchError((error) {
    print(error);
  });
}
