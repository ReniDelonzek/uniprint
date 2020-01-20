// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cadastro_aluno_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CadastroAlunoController on _CadastroAlunoBase, Store {
  final _$turnoAtom = Atom(name: '_CadastroAlunoBase.turno');

  @override
  Turno get turno {
    _$turnoAtom.context.enforceReadPolicy(_$turnoAtom);
    _$turnoAtom.reportObserved();
    return super.turno;
  }

  @override
  set turno(Turno value) {
    _$turnoAtom.context.conditionallyRunInAction(() {
      super.turno = value;
      _$turnoAtom.reportChanged();
    }, _$turnoAtom, name: '${_$turnoAtom.name}_set');
  }
}
