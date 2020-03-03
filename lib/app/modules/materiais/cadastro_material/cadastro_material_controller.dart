import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

part 'cadastro_material_controller.g.dart';

class CadastroMaterialController = _CadastroMaterialBase
    with _$CadastroMaterialController;

abstract class _CadastroMaterialBase with Store {
  final controllerTitulo = TextEditingController();
  final controllerDescricao = TextEditingController();

  @observable
  bool enviarArquivos = true;
  @observable
  Widget widget = Text('');
}
