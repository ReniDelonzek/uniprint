import 'package:intl/intl.dart';
import 'package:uniprint/app/shared/models/graph/movimentacao_g.dart';
import 'package:uniprint/app/shared/models/graph/usuario_g.dart';

class Atendimento {
  int id;
  int status;
  DateTime data_solicitacao;
  int ponto_atendimento_id;
  Usuario usuario;
  List<MovimentacaoAtendimento> movimentacao_atendimentos;

  Atendimento();

  toJson() {
    Map<String, dynamic> map = Map();
    map['id'] = id;
    map['status'] = status;
    map['data_solicitacao'] = data_solicitacao;
    map['usuario'] = usuario.toJson();

    return map;
  }

  factory Atendimento.fromJson(Map<String, dynamic> map) {
    Atendimento atendimento = Atendimento();
    atendimento.id = map['id'];
    atendimento.status = map['status'];
    atendimento.data_solicitacao = (map['data_solicitacao'] != null)
        ? DateFormat('yyyy-MM-ddTHH:mm:ss').parse(map['data_solicitacao'])
        : DateTime.now();
    atendimento.ponto_atendimento_id = map['ponto_atendimento_id'];
    atendimento.usuario = Usuario.fromMap(map['usuario']);
    atendimento.movimentacao_atendimentos = List<MovimentacaoAtendimento>.from(
        map['movimentacao_atendimentos']
            .map((i) => MovimentacaoAtendimento.fromMap(i))
            .toList());
    return atendimento;
  }
}
