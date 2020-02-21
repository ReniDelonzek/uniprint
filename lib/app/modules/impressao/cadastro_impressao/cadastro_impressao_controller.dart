import 'package:mobx/mobx.dart';
import 'package:uniprint/app/shared/models/graph/arquivo_impressao.dart';

part 'cadastro_impressao_controller.g.dart';

class CadastroImpressaoController = _CadastroImpressaoBase
    with _$CadastroImpressaoController;

abstract class _CadastroImpressaoBase with Store {
  @observable
  ObservableList<ArquivoImpressao> arquivos = ObservableList();

  _CadastroImpressaoBase({List<ArquivoImpressao> arquivos}) {
    if (arquivos != null) {
      for (ArquivoImpressao arquivoImpressao in arquivos) {
        this.arquivos.add(arquivoImpressao);
      }
    }
  }
}
