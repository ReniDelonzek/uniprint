// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeController on _HomeBase, Store {
  final _$userAtom = Atom(name: '_HomeBase.user');

  @override
  FirebaseUser get user {
    _$userAtom.context.enforceReadPolicy(_$userAtom);
    _$userAtom.reportObserved();
    return super.user;
  }

  @override
  set user(FirebaseUser value) {
    _$userAtom.context.conditionallyRunInAction(() {
      super.user = value;
      _$userAtom.reportChanged();
    }, _$userAtom, name: '${_$userAtom.name}_set');
  }

  final _$atendimentosAtom = Atom(name: '_HomeBase.atendimentos');

  @override
  ObservableList<Atendimento> get atendimentos {
    _$atendimentosAtom.context.enforceReadPolicy(_$atendimentosAtom);
    _$atendimentosAtom.reportObserved();
    return super.atendimentos;
  }

  @override
  set atendimentos(ObservableList<Atendimento> value) {
    _$atendimentosAtom.context.conditionallyRunInAction(() {
      super.atendimentos = value;
      _$atendimentosAtom.reportChanged();
    }, _$atendimentosAtom, name: '${_$atendimentosAtom.name}_set');
  }

  final _$impressoesAtom = Atom(name: '_HomeBase.impressoes');

  @override
  ObservableList<Impressao> get impressoes {
    _$impressoesAtom.context.enforceReadPolicy(_$impressoesAtom);
    _$impressoesAtom.reportObserved();
    return super.impressoes;
  }

  @override
  set impressoes(ObservableList<Impressao> value) {
    _$impressoesAtom.context.conditionallyRunInAction(() {
      super.impressoes = value;
      _$impressoesAtom.reportChanged();
    }, _$impressoesAtom, name: '${_$impressoesAtom.name}_set');
  }

  final _$exibirFabAtom = Atom(name: '_HomeBase.exibirFab');

  @override
  bool get exibirFab {
    _$exibirFabAtom.context.enforceReadPolicy(_$exibirFabAtom);
    _$exibirFabAtom.reportObserved();
    return super.exibirFab;
  }

  @override
  set exibirFab(bool value) {
    _$exibirFabAtom.context.conditionallyRunInAction(() {
      super.exibirFab = value;
      _$exibirFabAtom.reportChanged();
    }, _$exibirFabAtom, name: '${_$exibirFabAtom.name}_set');
  }
}
