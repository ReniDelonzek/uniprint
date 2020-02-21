import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:uniprint/app/shared/models/graph/disciplina.dart';
import 'package:uniprint/app/shared/models/graph/periodo.dart';

class Turma {
  DateTime data_inicio;
  DateTime data_final;
  Disciplina disciplina;
  Periodo periodo;
  Turma({
    this.data_inicio,
    this.data_final,
    this.disciplina,
    this.periodo,
  });

  Map<String, dynamic> toMap() {
    return {
      'data_inicio': data_inicio.millisecondsSinceEpoch,
      'data_final': data_final.millisecondsSinceEpoch,
      'disciplina': disciplina.toMap(),
      'periodo': periodo.toMap(),
    };
  }

  static Turma fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Turma(
      data_inicio: (map['data_inicio'] != null)
          ? DateFormat('yyyy-MM-dd').parse(map['data_inicio'])
          : DateTime.now(),
      data_final: (map['data_final'] != null)
          ? DateFormat('yyyy-MM-dd').parse(map['data_final'])
          : DateTime.now(),
      disciplina: Disciplina.fromMap(map['disciplina']),
      periodo: Periodo.fromMap(map['periodo']),
    );
  }

  String toJson() => json.encode(toMap());

  static Turma fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Turma data_inicio: $data_inicio, data_final: $data_final, disciplina: $disciplina, periodo: $periodo';
  }
}
