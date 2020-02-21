import 'dart:convert';

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
  String comentario_atendimento;
  int nota_atendimento;
  Atendimento({
    this.id,
    this.status,
    this.data_solicitacao,
    this.ponto_atendimento_id,
    this.usuario,
    this.movimentacao_atendimentos,
    this.comentario_atendimento,
    this.nota_atendimento,
  });

  Atendimento copyWith({
    int id,
    int status,
    DateTime data_solicitacao,
    int ponto_atendimento_id,
    Usuario usuario,
    List<MovimentacaoAtendimento> movimentacao_atendimentos,
    String comentario_atendimento,
    int nota_atendimento,
  }) {
    return Atendimento(
      id: id ?? this.id,
      status: status ?? this.status,
      data_solicitacao: data_solicitacao ?? this.data_solicitacao,
      ponto_atendimento_id: ponto_atendimento_id ?? this.ponto_atendimento_id,
      usuario: usuario ?? this.usuario,
      movimentacao_atendimentos:
          movimentacao_atendimentos ?? this.movimentacao_atendimentos,
      comentario_atendimento:
          comentario_atendimento ?? this.comentario_atendimento,
      nota_atendimento: nota_atendimento ?? this.nota_atendimento,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'data_solicitacao': data_solicitacao.millisecondsSinceEpoch,
      'ponto_atendimento_id': ponto_atendimento_id,
      'usuario': usuario.toMap(),
      'movimentacao_atendimentos':
          List<dynamic>.from(movimentacao_atendimentos.map((x) => x.toMap())),
      'comentario_atendimento': comentario_atendimento,
      'nota_atendimento': nota_atendimento,
    };
  }

  static Atendimento fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Atendimento(
      id: map['id'],
      status: map['status'],
      data_solicitacao: (map['data_solicitacao'] != null)
          ? DateFormat('yyyy-MM-ddTHH:mm:ss').parse(map['data_solicitacao'])
          : DateTime.now(),
      ponto_atendimento_id: map['ponto_atendimento_id'],
      usuario: Usuario.fromMap(map['usuario']),
      movimentacao_atendimentos: List<MovimentacaoAtendimento>.from(
          map['movimentacao_atendimentos']
              ?.map((x) => MovimentacaoAtendimento.fromMap(x))),
      comentario_atendimento: map['comentario_atendimento'],
      nota_atendimento: map['nota_atendimento'],
    );
  }

  String toJson() => json.encode(toMap());

  static Atendimento fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Atendimento id: $id, status: $status, data_solicitacao: $data_solicitacao, ponto_atendimento_id: $ponto_atendimento_id, usuario: $usuario, movimentacao_atendimentos: $movimentacao_atendimentos, comentario_atendimento: $comentario_atendimento, nota_atendimento: $nota_atendimento';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Atendimento &&
        o.id == id &&
        o.status == status &&
        o.data_solicitacao == data_solicitacao &&
        o.ponto_atendimento_id == ponto_atendimento_id &&
        o.usuario == usuario &&
        o.movimentacao_atendimentos == movimentacao_atendimentos &&
        o.comentario_atendimento == comentario_atendimento &&
        o.nota_atendimento == nota_atendimento;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        status.hashCode ^
        data_solicitacao.hashCode ^
        ponto_atendimento_id.hashCode ^
        usuario.hashCode ^
        movimentacao_atendimentos.hashCode ^
        comentario_atendimento.hashCode ^
        nota_atendimento.hashCode;
  }
}
