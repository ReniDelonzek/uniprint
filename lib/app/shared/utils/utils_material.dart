import 'package:uniprint/app/shared/models/graph/materiais/arquivo_material.dart';

class UtilsMaterial {
  static String getResumoArquivos(List<ArquivoMaterial> arquivos) {
    String s = "${arquivos.length} arquivos\n";
    return s.substring(0, s.lastIndexOf('\n'));
  }
}
