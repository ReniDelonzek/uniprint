import 'package:uniprint/app/shared/models/graph/materiais/arquivo_material.dart';
import 'package:uniprint/app/shared/models/graph/materiais/material.dart';

class UtilsMaterial {
  static String getResumoMaterial(MaterialProf material) {
    int pag = 0;
    if (material.arquivo_materials != null) {
      for (ArquivoMaterial arquivoMaterial in material.arquivo_materials) {
        pag += arquivoMaterial?.num_paginas ?? 1;
      }
    }
    return '${material?.arquivo_materials?.length} arquivo${(material.arquivo_materials?.length ?? 1) > 1 ? 's' : ''}, $pag página${pag > 1 ? 's' : ''}';
  }
}
