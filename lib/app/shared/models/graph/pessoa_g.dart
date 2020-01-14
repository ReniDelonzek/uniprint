class Pessoa {
  String nome;
  int id;

  Pessoa();

  toJson() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['nome'] = nome;
    map['id'] = id;
    return map;
  }

  factory Pessoa.fromJson(Map<String, dynamic> map) {
    Pessoa pessoa = Pessoa();
    if (map != null) {
      pessoa.nome = map['nome'];
      pessoa.id = map['id'];
    }
    return pessoa;
  }
}
