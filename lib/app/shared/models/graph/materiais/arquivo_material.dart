import 'dart:convert';

import 'package:uniprint/app/shared/models/graph/materiais/material.dart';

class ArquivoMaterial {
  MaterialProf material;
  String url;
  String nome;
  int num_paginas;

  String path;
  ArquivoMaterial({
    this.material,
    this.url,
    this.nome,
    this.num_paginas,
  });

  ArquivoMaterial copyWith({
    MaterialProf material,
    String url,
    String nome,
    int num_paginas,
  }) {
    return ArquivoMaterial(
      material: material ?? this.material,
      url: url ?? this.url,
      nome: nome ?? this.nome,
      num_paginas: num_paginas ?? this.num_paginas,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'nome': nome,
      'num_paginas': num_paginas,
    };
  }

  static ArquivoMaterial fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ArquivoMaterial(
      material: MaterialProf.fromMap(map['material']),
      url: map['url'],
      nome: map['nome'],
      num_paginas: map['num_paginas'],
    );
  }

  String toJson() => json.encode(toMap());

  static ArquivoMaterial fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() {
    return 'ArquivoMaterial material: $material, url: $url, nome: $nome, num_paginas: $num_paginas';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ArquivoMaterial &&
        o.material == material &&
        o.url == url &&
        o.nome == nome &&
        o.num_paginas == num_paginas;
  }

  @override
  int get hashCode {
    return material.hashCode ^
        url.hashCode ^
        nome.hashCode ^
        num_paginas.hashCode;
  }
}
