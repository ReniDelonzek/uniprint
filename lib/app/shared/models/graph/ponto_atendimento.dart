import 'dart:convert';

import 'package:uniprint/app/shared/models/graph/instituicao.dart';

class PontoAtendimento {
  String nome;
  Instituicao instituicao;
  PontoAtendimento({
    this.nome,
    this.instituicao,
  });
 
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'instituicao': instituicao.toMap(),
    };
  }

  static PontoAtendimento fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return PontoAtendimento(
      nome: map['nome'],
      instituicao: Instituicao.fromMap(map['instituicao']),
    );
  }

  String toJson() => json.encode(toMap());

  static PontoAtendimento fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'PontoAtendimento nome: $nome, instituicao: $instituicao';
 
}
