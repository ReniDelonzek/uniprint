import 'package:mobx/mobx.dart';
import 'package:uniprint/app/shared/widgets/pontos_atendimento/pontos_atendimento_controller.dart';

part 'cadastro_atendimento_controller.g.dart';

class CadastroAtendimentoController = _CadastroAtendimentoBase
    with _$CadastroAtendimentoController;

abstract class _CadastroAtendimentoBase with Store {
  final ctlPontosAtendimento = PontosAtendimentoController();
}
