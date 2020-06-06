import 'dart:convert';

import 'package:hive/hive.dart';

part 'menu.g.dart';

@HiveType(typeId: 4)
class Menu extends HiveObject {
  @HiveField(1)
  String nome;
  @HiveField(2)
  int id;
  @HiveField(3)
  int menuPaiId;
  Menu({
    this.nome,
    this.id,
    this.menuPaiId,
  });

  Menu copyWith({
    String nome,
    int id,
    int menuPaiId,
  }) {
    return Menu(
      nome: nome ?? this.nome,
      id: id ?? this.id,
      menuPaiId: menuPaiId ?? this.menuPaiId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'id': id,
      'menu_pai_id': menuPaiId,
    };
  }

  static Menu fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Menu(
      nome: map['nome'],
      id: map['id'],
      menuPaiId: map['menu_pai_id'],
    );
  }

  String toJson() => json.encode(toMap());

  static Menu fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Menu(nome: $nome, id: $id, menuPaiId: $menuPaiId)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Menu &&
        o.nome == nome &&
        o.id == id &&
        o.menuPaiId == menuPaiId;
  }

  @override
  int get hashCode => nome.hashCode ^ id.hashCode ^ menuPaiId.hashCode;
}
