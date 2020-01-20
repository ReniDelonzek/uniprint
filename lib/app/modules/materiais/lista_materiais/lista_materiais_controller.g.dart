// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lista_materiais_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ListaMateriaisController on _ListaMateriaisBase, Store {
  final _$materiaisAtom = Atom(name: '_ListaMateriaisBase.materiais');

  @override
  ObservableList<MaterialProf> get materiais {
    _$materiaisAtom.context.enforceReadPolicy(_$materiaisAtom);
    _$materiaisAtom.reportObserved();
    return super.materiais;
  }

  @override
  set materiais(ObservableList<MaterialProf> value) {
    _$materiaisAtom.context.conditionallyRunInAction(() {
      super.materiais = value;
      _$materiaisAtom.reportChanged();
    }, _$materiaisAtom, name: '${_$materiaisAtom.name}_set');
  }
}
