// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cadastro_impressao_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CadastroImpressaoController on _CadastroImpressaoBase, Store {
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
}
