// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arquivo_impressao.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ArquivoImpressao on _ArquivoImpressaoBase, Store {
  final _$coloridoAtom = Atom(name: '_ArquivoImpressaoBase.colorido');

  @override
  bool get colorido {
    _$coloridoAtom.context.enforceReadPolicy(_$coloridoAtom);
    _$coloridoAtom.reportObserved();
    return super.colorido;
  }

  @override
  set colorido(bool value) {
    _$coloridoAtom.context.conditionallyRunInAction(() {
      super.colorido = value;
      _$coloridoAtom.reportChanged();
    }, _$coloridoAtom, name: '${_$coloridoAtom.name}_set');
  }

  final _$quantidadeAtom = Atom(name: '_ArquivoImpressaoBase.quantidade');

  @override
  int get quantidade {
    _$quantidadeAtom.context.enforceReadPolicy(_$quantidadeAtom);
    _$quantidadeAtom.reportObserved();
    return super.quantidade;
  }

  @override
  set quantidade(int value) {
    _$quantidadeAtom.context.conditionallyRunInAction(() {
      super.quantidade = value;
      _$quantidadeAtom.reportChanged();
    }, _$quantidadeAtom, name: '${_$quantidadeAtom.name}_set');
  }

  final _$tipo_folha_idAtom = Atom(name: '_ArquivoImpressaoBase.tipo_folha_id');

  @override
  String get tipo_folha_id {
    _$tipo_folha_idAtom.context.enforceReadPolicy(_$tipo_folha_idAtom);
    _$tipo_folha_idAtom.reportObserved();
    return super.tipo_folha_id;
  }

  @override
  set tipo_folha_id(String value) {
    _$tipo_folha_idAtom.context.conditionallyRunInAction(() {
      super.tipo_folha_id = value;
      _$tipo_folha_idAtom.reportChanged();
    }, _$tipo_folha_idAtom, name: '${_$tipo_folha_idAtom.name}_set');
  }
}
