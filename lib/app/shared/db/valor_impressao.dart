import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:uniprint/app/shared/extensions/string.dart';

part 'valor_impressao.g.dart';

@HiveType(typeId: 2)
class ValorImpressao extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final double valor;
  @HiveField(3)
  final int tipo_folha_id;
  @HiveField(4)
  final DateTime data_inicio;
  @HiveField(5)
  final DateTime data_fim;
  @HiveField(6)
  final bool colorido;

  ValorImpressao(
    this.id,
    this.valor,
    this.tipo_folha_id,
    this.data_inicio,
    this.data_fim,
    this.colorido,
  );

  ValorImpressao copyWith({
    int id,
    double valor,
    String tipo_folha_id,
    DateTime data_inicio,
    DateTime data_fim,
    bool colorido,
  }) {
    return ValorImpressao(
      id ?? this.id,
      valor ?? this.valor,
      tipo_folha_id ?? this.tipo_folha_id,
      data_inicio ?? this.data_inicio,
      data_fim ?? this.data_fim,
      colorido ?? this.colorido,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'valor': valor,
      'tipo_folha_id': tipo_folha_id,
      'data_inicio': data_inicio.millisecondsSinceEpoch,
      'data_fim': data_fim.millisecondsSinceEpoch,
      'colorido': colorido,
    };
  }

  static ValorImpressao fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ValorImpressao(
      map['id'],
      map['valor'],
      map['tipo_folha_id'],
      map['data_inicio'].toString().dateFromHasura(DateTime.now()),
      map['data_fim'].toString().dateFromHasura(DateTime.now()),
      map['colorido'],
    );
  }

  String toJson() => json.encode(toMap());

  static ValorImpressao fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'ValorImpressao(id: $id, valor: $valor, tipo_folha_id: $tipo_folha_id, data_inicio: $data_inicio, data_fim: $data_fim, colorido: $colorido)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ValorImpressao &&
        o.id == id &&
        o.valor == valor &&
        o.tipo_folha_id == tipo_folha_id &&
        o.data_inicio == data_inicio &&
        o.data_fim == data_fim &&
        o.colorido == colorido;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        valor.hashCode ^
        tipo_folha_id.hashCode ^
        data_inicio.hashCode ^
        data_fim.hashCode ^
        colorido.hashCode;
  }
}
