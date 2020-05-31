import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:uniprint/app/shared/db/hive/tipo_folha.dart';
import 'package:uniprint/app/shared/models/graph/materiais/arquivo_material.dart';
import 'package:uniprint/app/shared/widgets/pontos_atendimento/pontos_atendimento_controller.dart';

part 'cadastro_material_controller.g.dart';

class CadastroMaterialController = _CadastroMaterialBase
    with _$CadastroMaterialController;

abstract class _CadastroMaterialBase with Store {
  final controllerTitulo = TextEditingController();
  final controllerDescricao = TextEditingController();
  final controllerPontosAtendimento = PontosAtendimentoController();
  TipoFolha tipoFolha;

  @observable
  int quantidade = 1;
  @observable
  bool colorido = false;
  @observable
  bool enviarArquivos = true;
  @observable
  Widget widget = Text('');
  @observable
  ObservableList<ArquivoMaterial> arquivos = ObservableList();
}
