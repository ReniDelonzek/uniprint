import 'package:mobx/mobx.dart';
import 'package:uniprint/app/shared/models/arquivo_impressao.dart';

part 'cadastro_impressao_controller.g.dart';

class CadastroImpressaoController = _CadastroImpressaoBase
    with _$CadastroImpressaoController;

abstract class _CadastroImpressaoBase with Store {
  @observable
  ObservableList<ArquivoImpressao> arquivos = ObservableList();

  _CadastroImpressaoBase({this.arquivos}) {
    if (arquivos != null) {
      this.arquivos.addAll(arquivos);
    }
  }
}
