import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:uniprint/app/shared/models/graph/detalhes_usuario.dart';
import 'package:uniprint/app/shared/network/graph_ql_data.dart';
import 'package:uniprint/app/shared/network/querys.dart';
import 'package:uniprint/app/shared/utils/utils_sentry.dart';

class DetalhesUsuarioService extends Disposable {
  DetalhesUsuario detalhesUsuario;

  Future<DetalhesUsuario> recuperarDados(int usuarioID) async {
    try {
      var res = await GraphQlObject.hasuraConnect
          .query(getDetalhesUsuUsuario, variables: {'usuario_id': usuarioID});
      if (res != null && res.containsKey('data')) {
        detalhesUsuario = DetalhesUsuario();
        detalhesUsuario.numAtendimentos =
            res['data']['atendimento_aggregate']['aggregate']['count'];
        detalhesUsuario.numImpressoes =
            res['data']['impressao_aggregate']['aggregate']['count'];
        return detalhesUsuario;
      }
    } catch (error, stackTrace) {
      UtilsSentry.reportError(error, stackTrace);
    }
    return null;
  }

  @override
  void dispose() {
    detalhesUsuario = null;
  }
}
