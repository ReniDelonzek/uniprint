import 'package:mobx/mobx.dart';
import 'package:uniprint/app/shared/models/graph/ponto_atendimento.dart';

part 'pontos_atendimento_controller.g.dart';

class PontosAtendimentoController = _PontosAtendimentoBase
    with _$PontosAtendimentoController;

abstract class _PontosAtendimentoBase with Store {
  @observable
  PontoAtendimento pontoAtendimento;
}
