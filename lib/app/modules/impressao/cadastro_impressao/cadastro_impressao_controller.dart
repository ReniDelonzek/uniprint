import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:uniprint/app/shared/auth/hasura_auth_service.dart';
import 'package:uniprint/app/shared/models/graph/arquivo_impressao.dart';
import 'package:uniprint/app/shared/models/graph/ponto_atendimento.dart';
import 'package:uniprint/app/shared/network/graph_ql_data.dart';
import 'package:uniprint/app/shared/network/mutations.dart';
import 'package:uniprint/app/shared/network/querys.dart';
import 'package:uniprint/app/shared/utils/constans.dart';
import 'package:uniprint/app/shared/utils/utils_firebase_file.dart';
import 'package:uniprint/app/shared/utils/utils_impressao.dart';
import 'package:uniprint/app/shared/utils/utils_sentry.dart';
import 'package:uniprint/app/shared/widgets/pontos_atendimento/pontos_atendimento_controller.dart';

import '../../../app_module.dart';

part 'cadastro_impressao_controller.g.dart';

class CadastroImpressaoController = _CadastroImpressaoBase
    with _$CadastroImpressaoController;

abstract class _CadastroImpressaoBase with Store {
  @observable
  PontoAtendimento local;
  final TextEditingController controllerObs = TextEditingController();
  final PontosAtendimentoController ctlPontosAtendimento =
      PontosAtendimentoController();

  @observable
  ObservableList<ArquivoImpressao> arquivos = ObservableList();

  _CadastroImpressaoBase({List<ArquivoImpressao> arquivos}) {
    if (arquivos != null) {
      for (ArquivoImpressao arquivoImpressao in arquivos) {
        this.arquivos.add(arquivoImpressao);
      }
    }
  }

  @action
  Future cadastrarDados() async {
    DateTime data = DateTime.now();
    for (int i = 0; i < arquivos.length; i++) {
      if (arquivos[i].url == null || arquivos[i].url.isEmpty) {
        File file = File(arquivos[i].path);
        arquivos[i].url = await UtilsFirebaseFile.putFile(file,
            'Impressoes/${AppModule.to.getDependency<HasuraAuthService>().usuario?.codHasura}/${DateFormat('yyyyMMddHHmm').format(data)}/${file.path.split('/').last}');
      }
    }
    return await GraphQlObject.hasuraConnect
        .mutation(Mutations.cadastroImpressao, variables: {
      'data': DateFormat('yyyy-MM-dd HH:mm:ss').format(data),
      'usuario_id':
          (AppModule.to.getDependency<HasuraAuthService>().usuario.codHasura),
      'ponto_atendimento_id': local.id,
      'tipo': Constants.MOV_IMPRESSAO_SOLICITADO,
      'comentario': controllerObs.text,
      'arquivos': arquivos?.toList()?.map((a) => a.toJson())?.toList() ?? '[]'
    });
  }

  @action
  String verificarDados() {
    if (local == null) {
      return "Você precisa selecinar o local da impressão";
    } else if (arquivos?.isEmpty == true) {
      return "Você precisa selecinar pelo menos um arquivo";
    } else
      return null;
  }

  Future<String> validarPermissao() async {
    double valorMax = 3;
    try {
      var res = await GraphQlObject.hasuraConnect
          .query(Querys.getValorMaximoImpressao, variables: {
        'usuario_id':
            AppModule.to.getDependency<HasuraAuthService>().usuario.codHasura
      });
      if (res != null &&
          res.containsKey("data") &&
          res['data'].containsKey('valor_max_impressao')) {
        valorMax = res['data']['nivel_usuario'][0]['nivel']
                ['valor_max_impressao'] ??
            3;
      }
    } catch (error, stackTrace) {
      UtilsSentry.reportError(error, stackTrace);
    }
    double valor = await UtilsImpressao.getValorImpressaoArquivos(arquivos);
    if (valor > valorMax) {
      return 'Infelizmente você não tem reputação suficiente para imprimir essa quantia toda de uma vez, você só pode imprimir até R\$: ${NumberFormat('0.00').format(valorMax)} reais.\nSua reputação cresce com a gente a medida que você usa nossa plataforma, então continue usando para ter um limite maior ˆˆ ';
    } else
      return null;
  }
}
