// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tipo_folha_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TipoFolhaController on _TipoFolhaBase, Store {
  final _$tipoFolhaAtom = Atom(name: '_TipoFolhaBase.tipoFolha');

  @override
  TipoFolha get tipoFolha {
    _$tipoFolhaAtom.context.enforceReadPolicy(_$tipoFolhaAtom);
    _$tipoFolhaAtom.reportObserved();
    return super.tipoFolha;
  }

  @override
  set tipoFolha(TipoFolha value) {
    _$tipoFolhaAtom.context.conditionallyRunInAction(() {
      super.tipoFolha = value;
      _$tipoFolhaAtom.reportChanged();
    }, _$tipoFolhaAtom, name: '${_$tipoFolhaAtom.name}_set');
  }
}
