import 'dart:convert';

class TipoFolha {
  int id;
  String nome;
  TipoFolha({
    this.id,
    this.nome,
  });

  TipoFolha copyWith({
    int id,
    String nome,
  }) {
    return TipoFolha(
      id: id ?? this.id,
      nome: nome ?? this.nome,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  static TipoFolha fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TipoFolha(
      id: map['id'],
      nome: map['nome'],
    );
  }

  String toJson() => json.encode(toMap());

  static TipoFolha fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'TipoFolha id: $id, nome: $nome';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TipoFolha && o.id == id && o.nome == nome;
  }

  @override
  int get hashCode => id.hashCode ^ nome.hashCode;

  static List<TipoFolha> getTamanhoFolhas() {
    return [TipoFolha(id: 1, nome: 'A4'), TipoFolha(id: 2, nome: 'A3')];
  }
}
