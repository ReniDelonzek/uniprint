import 'dart:convert';

import 'package:uniprint/app/shared/db/hive/tipo_folha.dart';
import 'package:uniprint/app/shared/extensions/date.dart';
import 'package:uniprint/app/shared/extensions/string.dart';
import 'package:uniprint/app/shared/models/graph/materiais/arquivo_material.dart';
import 'package:uniprint/app/shared/models/graph/professor.dart';
import 'package:uniprint/app/shared/models/graph/usuario_g.dart';

import '../ponto_atendimento.dart';

class MaterialProf {
  DateTime data_publicacao;
  int tipo;
  String titulo;
  TipoFolha tipo_folha;
  bool colorido;
  PontoAtendimento ponto_atendimento;
  List<ArquivoMaterial> arquivo_materials;
  Usuario usuario;
  String descricao;
  MaterialProf({
    this.data_publicacao,
    this.tipo,
    this.titulo,
    this.tipo_folha,
    this.colorido,
    this.ponto_atendimento,
    this.arquivo_materials,
    this.usuario,
    this.descricao,
  });

  MaterialProf copyWith({
    DateTime data_publicacao,
    int tipo,
    String titulo,
    TipoFolha tipo_folha,
    bool colorido,
    PontoAtendimento ponto_atendimento,
    List<ArquivoMaterial> arquivo_materials,
    Professor professor,
    String descricao,
  }) {
    return MaterialProf(
      data_publicacao: data_publicacao ?? this.data_publicacao,
      tipo: tipo ?? this.tipo,
      titulo: titulo ?? this.titulo,
      tipo_folha: tipo_folha ?? this.tipo_folha,
      colorido: colorido ?? this.colorido,
      ponto_atendimento: ponto_atendimento ?? this.ponto_atendimento,
      arquivo_materials: arquivo_materials ?? this.arquivo_materials,
      usuario: professor ?? this.usuario,
      descricao: descricao ?? this.descricao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data_publicacao': data_publicacao.hasuraFormat(),
      'tipo': tipo,
      'titulo': titulo,
      'tipo_folha': tipo_folha.toMap(),
      'colorido': colorido,
      'ponto_atendimento': ponto_atendimento.toMap(),
      'arquivo_materials':
          List<dynamic>.from(arquivo_materials.map((x) => x.toMap())),
      'usuario': usuario.toMap(),
      'descricao': descricao,
    };
  }

  static MaterialProf fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MaterialProf(
      data_publicacao:
          map['data_publicacao'].toString().dateFromHasura(DateTime.now()),
      tipo: map['tipo'],
      titulo: map['titulo'],
      tipo_folha: TipoFolha.fromMap(map['tipo_folha']),
      colorido: map['colorido'],
      ponto_atendimento: PontoAtendimento.fromMap(map['ponto_atendimento']),
      arquivo_materials: List<ArquivoMaterial>.from(
          map['arquivo_materials']?.map((x) => ArquivoMaterial.fromMap(x))),
      usuario: Usuario.fromMap(map['usuario']),
      descricao: map['descricao'],
    );
  }

  String toJson() => json.encode(toMap());

  static MaterialProf fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'MaterialProf data_publicacao: $data_publicacao, tipo: $tipo, titulo: $titulo, tipo_folha: $tipo_folha, colorido: $colorido, ponto_atendimento: $ponto_atendimento, arquivo_materials: $arquivo_materials, usuario: $usuario, descricao: $descricao';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MaterialProf &&
        o.data_publicacao == data_publicacao &&
        o.tipo == tipo &&
        o.titulo == titulo &&
        o.tipo_folha == tipo_folha &&
        o.colorido == colorido &&
        o.ponto_atendimento == ponto_atendimento &&
        o.arquivo_materials == arquivo_materials &&
        o.usuario == usuario &&
        o.descricao == descricao;
  }

  @override
  int get hashCode {
    return data_publicacao.hashCode ^
        tipo.hashCode ^
        titulo.hashCode ^
        tipo_folha.hashCode ^
        colorido.hashCode ^
        ponto_atendimento.hashCode ^
        arquivo_materials.hashCode ^
        usuario.hashCode ^
        descricao.hashCode;
  }
}
