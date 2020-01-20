import 'package:mobx/mobx.dart';

part 'arquivo_impressao.g.dart';

class ArquivoImpressao = _ArquivoImpressaoBase with _$ArquivoImpressao;

abstract class _ArquivoImpressaoBase with Store {
  String url;
  String nome;
  @observable
  bool colorido;
  String codImpressao;
  @observable
  int quantidade;
  @observable
  String tipo_folha_id;

  //ingorar
  String patch;
  _ArquivoImpressaoBase({
    this.url,
    this.nome,
    this.colorido,
    this.codImpressao,
    this.quantidade,
    this.tipo_folha_id,
    this.patch,
  });

  Map<String, dynamic> toJson() => {
        'url': url,
        'nome': nome,
        'colorido': colorido,
        'quantidade': quantidade,
        'tipo_folha_id': 1,
      };

  factory _ArquivoImpressaoBase.fromMap(Map<String, dynamic> map) {
    return ArquivoImpressao(
      url: map['url'] ?? '',
      nome: map['nome'] ?? '',
      colorido: map['colorido'] ?? false,
      quantidade: map['quantidade'] ?? 0,
      tipo_folha_id: map['tipo_folha_id'] ?? 0
    );
  }
}
