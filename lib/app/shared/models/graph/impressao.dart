import 'dart:convert';

import 'package:uniprint/app/shared/models/graph/movimentacao_impressao.dart';
import 'package:uniprint/app/shared/models/graph/usuario_g.dart';

import 'arquivo_impressao.dart';

class Impressao {
  int id;
  String comentario;
  int status;
  List<ArquivoImpressao> arquivo_impressaos;
  List<MovimentacaoImpressao> movimentacao_impressaos;
  Usuario usuario;
  double valorTotal;
  Impressao(
      {this.id,
      this.comentario,
      this.status,
      this.arquivo_impressaos,
      this.movimentacao_impressaos,
      this.usuario,
      this.valorTotal});

  Impressao copyWith({
    int id,
    String comentario,
    int status,
    List<ArquivoImpressao> arquivo_impressaos,
    List<MovimentacaoImpressao> movimentacao_impressaos,
    Usuario usuario,
  }) {
    return Impressao(
      id: id ?? this.id,
      comentario: comentario ?? this.comentario,
      status: status ?? this.status,
      arquivo_impressaos: arquivo_impressaos ?? this.arquivo_impressaos,
      movimentacao_impressaos:
          movimentacao_impressaos ?? this.movimentacao_impressaos,
      usuario: usuario ?? this.usuario,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'comentario': comentario,
      'status': status,
      'arquivo_impressaos':
          List<dynamic>.from(arquivo_impressaos.map((x) => x.toJson())),
      'movimentacao_impressaos':
          List<dynamic>.from(movimentacao_impressaos.map((x) => x.toMap())),
      'usuario': usuario.toMap(),
    };
  }

  static Impressao fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Impressao(
        id: map['id'],
        comentario: map['comentario'],
        status: map['status'],
        arquivo_impressaos: List<ArquivoImpressao>.from(
            map['arquivo_impressaos']?.map((x) => ArquivoImpressao.fromMap(x))),
        movimentacao_impressaos: List<MovimentacaoImpressao>.from(
            map['movimentacao_impressaos']
                ?.map((x) => MovimentacaoImpressao.fromMap(x))),
        usuario: Usuario.fromMap(map['usuario']),
        valorTotal: map['valor_total']);
  }

  String toJson() => json.encode(toMap());

  static Impressao fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Impressao id: $id, comentario: $comentario, status: $status, arquivo_impressaos: $arquivo_impressaos, movimentacao_impressaos: $movimentacao_impressaos, usuario: $usuario';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Impressao &&
        o.id == id &&
        o.comentario == comentario &&
        o.status == status &&
        o.arquivo_impressaos == arquivo_impressaos &&
        o.movimentacao_impressaos == movimentacao_impressaos &&
        o.usuario == usuario;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        comentario.hashCode ^
        status.hashCode ^
        arquivo_impressaos.hashCode ^
        movimentacao_impressaos.hashCode ^
        usuario.hashCode;
  }
}
