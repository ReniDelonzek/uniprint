// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cadastro_impressao_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CadastroImpressaoController on _CadastroImpressaoBase, Store {
  final _$localAtom = Atom(name: '_CadastroImpressaoBase.local');

  @override
  PontoAtendimento get local {
    _$localAtom.context.enforceReadPolicy(_$localAtom);
    _$localAtom.reportObserved();
    return super.local;
  }

  @override
  set local(PontoAtendimento value) {
    _$localAtom.context.conditionallyRunInAction(() {
      super.local = value;
      _$localAtom.reportChanged();
    }, _$localAtom, name: '${_$localAtom.name}_set');
  }

  final _$arquivosAtom = Atom(name: '_CadastroImpressaoBase.arquivos');

  @override
  ObservableList<ArquivoImpressao> get arquivos {
    _$arquivosAtom.context.enforceReadPolicy(_$arquivosAtom);
    _$arquivosAtom.reportObserved();
    return super.arquivos;
  }

  @override
  set arquivos(ObservableList<ArquivoImpressao> value) {
    _$arquivosAtom.context.conditionallyRunInAction(() {
      super.arquivos = value;
      _$arquivosAtom.reportChanged();
    }, _$arquivosAtom, name: '${_$arquivosAtom.name}_set');
  }

  final _$cadastrarDadosAsyncAction = AsyncAction('cadastrarDados');

  @override
  Future cadastrarDados() {
    return _$cadastrarDadosAsyncAction.run(() => super.cadastrarDados());
  }

  final _$_CadastroImpressaoBaseActionController =
      ActionController(name: '_CadastroImpressaoBase');

  @override
  String verificarDados() {
    final _$actionInfo = _$_CadastroImpressaoBaseActionController.startAction();
    try {
      return super.verificarDados();
    } finally {
      _$_CadastroImpressaoBaseActionController.endAction(_$actionInfo);
    }
  }
}
