// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_email_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginEmailController on _LoginEmailBase, Store {
  final _$exibirSenhaAtom = Atom(name: '_LoginEmailBase.exibirSenha');

  @override
  bool get exibirSenha {
    _$exibirSenhaAtom.context.enforceReadPolicy(_$exibirSenhaAtom);
    _$exibirSenhaAtom.reportObserved();
    return super.exibirSenha;
  }

  @override
  set exibirSenha(bool value) {
    _$exibirSenhaAtom.context.conditionallyRunInAction(() {
      super.exibirSenha = value;
      _$exibirSenhaAtom.reportChanged();
    }, _$exibirSenhaAtom, name: '${_$exibirSenhaAtom.name}_set');
  }
}
