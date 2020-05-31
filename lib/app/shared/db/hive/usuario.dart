import 'dart:convert';

import 'package:hive/hive.dart';

part 'usuario.g.dart';

@HiveType(typeId: 1)
class UsuarioHasura extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String nome;
  @HiveField(2)
  int codHasura;
  @HiveField(3)
  int codProfessor;
  UsuarioHasura({this.id, this.nome, this.codHasura, this.codProfessor});

  UsuarioHasura copyWith(
      {int id, String nome, int codHasura, int codProfessor}) {
    return UsuarioHasura(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        codHasura: codHasura ?? this.codHasura,
        codProfessor: codProfessor ?? this.codProfessor);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'codHasura': codHasura,
      'codProfessor': codProfessor
    };
  }

  static UsuarioHasura fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UsuarioHasura(
        id: map['id'],
        nome: map['nome'],
        codHasura: map['codHasura'],
        codProfessor: map['codProfessor']);
  }

  String toJson() => json.encode(toMap());

  static UsuarioHasura fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Usuario id: $id, nome: $nome, codHasura: $codHasura';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UsuarioHasura &&
        o.id == id &&
        o.nome == nome &&
        o.codHasura == codHasura;
  }

  @override
  int get hashCode => id.hashCode ^ nome.hashCode ^ codHasura.hashCode;
}
