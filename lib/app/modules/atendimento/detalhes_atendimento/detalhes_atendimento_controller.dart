import 'package:mobx/mobx.dart';

part 'detalhes_atendimento_controller.g.dart';

class DetalhesAtendimentoController = _DetalhesAtendimentoBase
    with _$DetalhesAtendimentoController;

abstract class _DetalhesAtendimentoBase with Store {
  @observable
  double avaliacao = 4;
  @observable
  bool mostrarBotaoSalvarAvaliacao = false;
}
