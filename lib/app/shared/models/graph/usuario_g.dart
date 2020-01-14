import 'package:uniprint/app/shared/models/graph/pessoa_g.dart';

class Usuario {
  String email;
  String uid;
  String url_foto;

  Pessoa pessoa;

  Usuario();

  factory Usuario.fromJson(Map<String, dynamic> map) {
    Usuario usuario = Usuario();
    if (map != null) {
      usuario.email = map['email'];
      usuario.uid = map['uid'];
      usuario.url_foto = map['url_foto'];
      usuario.pessoa = Pessoa.fromJson(map['pessoa']);
    }
    return usuario;
  }

  toJson() {
    Map<String, dynamic> map = Map();
    map['email'] = email;
    map['uid'] = uid;
    map['url_foto'] = url_foto;
    map['pessoa'] = pessoa.toString();
    return map;
  }
}
