import 'package:mobx/mobx.dart';
import 'package:uniprint/app/shared/db/hive/tipo_folha.dart';
import 'package:uniprint/app/shared/models/graph/arquivo_impressao.dart';
import 'package:uniprint/app/shared/models/graph/materiais/arquivo_material.dart';
import 'package:uniprint/app/shared/models/graph/materiais/material.dart';
part 'lista_materiais_controller.g.dart';

class ListaMateriaisController = _ListaMateriaisBase
    with _$ListaMateriaisController;

abstract class _ListaMateriaisBase with Store {
  @observable
  ObservableList<MaterialProf> materiais = ObservableList();

  @action
  Future<List<ArquivoImpressao>> getArquivosImpressao(
      MaterialProf material) async {
    List<ArquivoImpressao> arquivos = List();
    if (material.arquivo_materials != null &&
        material.arquivo_materials.isNotEmpty) {
      for (ArquivoMaterial arquivoMaterial in material.arquivo_materials) {
        ArquivoImpressao arquivo = ArquivoImpressao();
        arquivo.nome = arquivoMaterial.nome;
        arquivo.url = arquivoMaterial.url;
        arquivo.colorido = material.colorido ?? false;
        arquivo.quantidade = 1;
        arquivo.tipoFolha = (await TipoFolha.getTiposFolha()).first;
        arquivo.tipo_folha_id = arquivo.tipoFolha.id;
        arquivo.num_paginas = arquivoMaterial.num_paginas;
        arquivos.add(arquivo);
      }
    }
    return arquivos;
  }
}
