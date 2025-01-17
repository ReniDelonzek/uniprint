import 'package:mobx/mobx.dart';
import 'package:uniprint/app/app_module.dart';
import 'package:uniprint/app/shared/db/hive/tipo_folha.dart';

part 'tipo_folha_controller.g.dart';

class TipoFolhaController = _TipoFolhaBase with _$TipoFolhaController;

abstract class _TipoFolhaBase with Store {
  @observable
  TipoFolha tipoFolha;

  _TipoFolhaBase(this.tipoFolha);

  getTiposFolha() async {
    TipoFolha tipoFolha = AppModule.to.getDependency<TipoFolha>();
    if (tipoFolha.tiposFolha?.isEmpty ?? true) {
      tipoFolha.tiposFolha = await TipoFolha.getTiposFolha();
    }

    return tipoFolha.tiposFolha;
  }
}
