import 'package:flutter/widgets.dart';

typedef Funcao = void Function({dynamic data});

class Acao {
  Map<String, String>
      chaves; //keys das colunas a serem enviadas, e o nome como elas devem ir
  String descricao;
  WidgetBuilder route;
  bool edicao;
  Funcao funcao;
  Icon icon;

  Acao(
      {this.descricao,
      this.route,
      this.chaves,
      this.edicao,
      this.funcao,
      this.icon});
}
