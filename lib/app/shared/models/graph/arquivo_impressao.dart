import 'package:mobx/mobx.dart';
import 'package:uniprint/app/shared/models/graph/tipo_folha.dart';

part 'arquivo_impressao.g.dart';

class ArquivoImpressao extends _ArquivoImpressaoBase with _$ArquivoImpressao {
  ArquivoImpressao(
      {String url,
      String nome,
      bool colorido,
      int quantidade,
      int tipo_folha_id,
      int num_paginas,
      TipoFolha tipoFolha})
      : super(
            url: url,
            nome: nome,
            colorido: colorido,
            quantidade: quantidade,
            tipo_folha_id: tipo_folha_id,
            tipoFolha: tipoFolha,
            num_paginas: num_paginas);
  factory ArquivoImpressao.fromMap(Map<String, dynamic> map) {
    return ArquivoImpressao(
        url: map['url'],
        nome: map['nome'],
        colorido: map['colorido'],
        quantidade: map['quantidade'],
        tipo_folha_id: map['tipo_folha_id'],
        num_paginas: map['num_paginas'],
        tipoFolha: TipoFolha.fromMap(map['tipofolha']));
  }
}

abstract class _ArquivoImpressaoBase with Store {
  String url;
  String nome;
  @observable
  bool colorido;
  @observable
  int quantidade;
  int tipo_folha_id;
  @observable
  TipoFolha tipoFolha;
  int num_paginas;

  //ingorar
  String patch;
  _ArquivoImpressaoBase(
      {this.url,
      this.nome,
      this.colorido,
      this.quantidade,
      this.tipo_folha_id,
      this.patch,
      this.tipoFolha,
      this.num_paginas});

  Map<String, dynamic> toJson() => {
        'url': url,
        'nome': nome,
        'colorido': colorido,
        'quantidade': quantidade,
        'tipo_folha_id': 1,
        'num_paginas': num_paginas
      };
}
