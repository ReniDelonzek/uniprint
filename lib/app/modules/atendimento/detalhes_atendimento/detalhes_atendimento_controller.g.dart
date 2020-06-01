// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detalhes_atendimento_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DetalhesAtendimentoController on _DetalhesAtendimentoBase, Store {
  final _$avaliacaoAtom = Atom(name: '_DetalhesAtendimentoBase.avaliacao');

  @override
  double get avaliacao {
    _$avaliacaoAtom.context.enforceReadPolicy(_$avaliacaoAtom);
    _$avaliacaoAtom.reportObserved();
    return super.avaliacao;
  }

  @override
  set avaliacao(double value) {
    _$avaliacaoAtom.context.conditionallyRunInAction(() {
      super.avaliacao = value;
      _$avaliacaoAtom.reportChanged();
    }, _$avaliacaoAtom, name: '${_$avaliacaoAtom.name}_set');
  }

  final _$mostrarBotaoSalvarAvaliacaoAtom =
      Atom(name: '_DetalhesAtendimentoBase.mostrarBotaoSalvarAvaliacao');

  @override
  bool get mostrarBotaoSalvarAvaliacao {
    _$mostrarBotaoSalvarAvaliacaoAtom.context
        .enforceReadPolicy(_$mostrarBotaoSalvarAvaliacaoAtom);
    _$mostrarBotaoSalvarAvaliacaoAtom.reportObserved();
    return super.mostrarBotaoSalvarAvaliacao;
  }

  @override
  set mostrarBotaoSalvarAvaliacao(bool value) {
    _$mostrarBotaoSalvarAvaliacaoAtom.context.conditionallyRunInAction(() {
      super.mostrarBotaoSalvarAvaliacao = value;
      _$mostrarBotaoSalvarAvaliacaoAtom.reportChanged();
    }, _$mostrarBotaoSalvarAvaliacaoAtom,
        name: '${_$mostrarBotaoSalvarAvaliacaoAtom.name}_set');
  }
}
