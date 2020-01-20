// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_email_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginEmailController on _LoginEmailBase, Store {
  final _$obscureAtom = Atom(name: '_LoginEmailBase.obscure');

  @override
  bool get obscure {
    _$obscureAtom.context.enforceReadPolicy(_$obscureAtom);
    _$obscureAtom.reportObserved();
    return super.obscure;
  }

  @override
  set obscure(bool value) {
    _$obscureAtom.context.conditionallyRunInAction(() {
      super.obscure = value;
      _$obscureAtom.reportChanged();
    }, _$obscureAtom, name: '${_$obscureAtom.name}_set');
  }
}
