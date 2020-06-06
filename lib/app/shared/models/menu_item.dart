import 'package:flutter/material.dart';
import 'package:uniprint/app/shared/models/acao.dart';

class MenuItem {
  int codSistema;
  String titulo;
  Acao acao;
  List<MenuItem> subMenus;
  Widget icone;
  bool exibirSempre;
  MenuItem(
      {this.codSistema,
      this.titulo,
      this.acao,
      this.subMenus,
      this.icone,
      this.exibirSempre});
}
