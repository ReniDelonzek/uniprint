import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:uniprint/app/shared/models/graph/materiais/arquivo_material.dart';

import '../ponto_atendimento.dart';
import '../professor_turma.dart';
import '../tipo_folha.dart';

class MaterialProf {
  DateTime data_publicacao;
  int tipo;
  String titulo;
  TipoFolha tipo_folha;
  bool colorido;
  PontoAtendimento ponto_atendimento;
  ProfessorTurma professor_turma;
  List<ArquivoMaterial> arquivo_materials;
  MaterialProf({
    this.data_publicacao,
    this.tipo,
    this.titulo,
    this.tipo_folha,
    this.colorido,
    this.ponto_atendimento,
    this.professor_turma,
    this.arquivo_materials,
  });

  MaterialProf copyWith({
    DateTime data_publicacao,
    int tipo,
    String titulo,
    TipoFolha tipo_folha,
    bool colorido,
    PontoAtendimento ponto_atendimento,
    ProfessorTurma professor_turma,
    List<ArquivoMaterial> arquivos,
  }) {
    return MaterialProf(
      data_publicacao: data_publicacao ?? this.data_publicacao,
      tipo: tipo ?? this.tipo,
      titulo: titulo ?? this.titulo,
      tipo_folha: tipo_folha ?? this.tipo_folha,
      colorido: colorido ?? this.colorido,
      ponto_atendimento: ponto_atendimento ?? this.ponto_atendimento,
      professor_turma: professor_turma ?? this.professor_turma,
      arquivo_materials: arquivos ?? this.arquivo_materials,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data_publicacao': data_publicacao.millisecondsSinceEpoch,
      'tipo': tipo,
      'titulo': titulo,
      'tipo_folha': tipo_folha.toMap(),
      'colorido': colorido,
      'ponto_atendimento': ponto_atendimento.toMap(),
      'professor_turma': professor_turma.toMap(),
      'arquivos': List<dynamic>.from(arquivo_materials.map((x) => x.toMap())),
    };
  }

  static MaterialProf fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MaterialProf(
      data_publicacao: (map['data_publicacao'] != null)
          ? DateFormat('yyyy-MM-ddTHH:mm:ss').parse(map['data_publicacao'])
          : DateTime
              .now(), //DateTime.fromMillisecondsSinceEpoch(map['data_publicacao']),
      tipo: map['tipo'],
      titulo: map['titulo'],
      tipo_folha: TipoFolha.fromMap(map['tipo_folha']),
      colorido: map['colorido'],
      ponto_atendimento: PontoAtendimento.fromMap(map['ponto_atendimento']),
      professor_turma: ProfessorTurma.fromMap(map['professor_turma']),
      arquivo_materials: map.containsKey('arquivo_materials')
          ? List<ArquivoMaterial>.from(
              map['arquivo_materials']?.map((x) => ArquivoMaterial.fromMap(x)))
          : List(),
    );
  }

  String toJson() => json.encode(toMap());

  static MaterialProf fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'MaterialProf data_publicacao: $data_publicacao, tipo: $tipo, titulo: $titulo, tipo_folha: $tipo_folha, colorido: $colorido, ponto_atendimento: $ponto_atendimento, professor_turma: $professor_turma, arquivos: $arquivo_materials';
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
        o.professor_turma == professor_turma &&
        o.arquivo_materials == arquivo_materials;
  }

  @override
  int get hashCode {
    return data_publicacao.hashCode ^
        tipo.hashCode ^
        titulo.hashCode ^
        tipo_folha.hashCode ^
        colorido.hashCode ^
        ponto_atendimento.hashCode ^
        professor_turma.hashCode ^
        arquivo_materials.hashCode;
  }
}
