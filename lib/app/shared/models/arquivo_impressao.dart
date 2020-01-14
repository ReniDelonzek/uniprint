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

  Map<String, dynamic> toJson() => {
        'url': url,
        'nome': nome,
        'colorido': colorido,
        'quantidade': quantidade,
        'tipo_folha_id': 1,
      };
}
