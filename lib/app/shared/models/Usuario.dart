import 'package:uniprint/app/shared/models/graph/pessoa_g.dart';

class Usuario {
  String id;
  String nome;
  String email;
  Pessoa pessoa;

  toJson() {
    Map<String, dynamic> map = Map();
    map['id'] = id;
    map['nome'] = nome;
    map['email'] = email;
    map['pessoa'] = pessoa.toString();
    return map;
  }

  static Usuario fromJson(Map<String, dynamic> map) {
    Usuario usuario = Usuario();
    usuario.nome = map['nome'];
    usuario.email = map['email'];
    usuario.pessoa = Pessoa.fromJson(map['pessoa']);
    return usuario;
  }
}
