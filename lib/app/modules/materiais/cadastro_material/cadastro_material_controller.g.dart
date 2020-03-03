// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cadastro_material_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CadastroMaterialController on _CadastroMaterialBase, Store {
  final _$enviarArquivosAtom =
      Atom(name: '_CadastroMaterialBase.enviarArquivos');

  @override
  bool get enviarArquivos {
    _$enviarArquivosAtom.context.enforceReadPolicy(_$enviarArquivosAtom);
    _$enviarArquivosAtom.reportObserved();
    return super.enviarArquivos;
  }

  @override
  set enviarArquivos(bool value) {
    _$enviarArquivosAtom.context.conditionallyRunInAction(() {
      super.enviarArquivos = value;
      _$enviarArquivosAtom.reportChanged();
    }, _$enviarArquivosAtom, name: '${_$enviarArquivosAtom.name}_set');
  }

  final _$widgetAtom = Atom(name: '_CadastroMaterialBase.widget');

  @override
  Widget get widget {
    _$widgetAtom.context.enforceReadPolicy(_$widgetAtom);
    _$widgetAtom.reportObserved();
    return super.widget;
  }

  @override
  set widget(Widget value) {
    _$widgetAtom.context.conditionallyRunInAction(() {
      super.widget = value;
      _$widgetAtom.reportChanged();
    }, _$widgetAtom, name: '${_$widgetAtom.name}_set');
  }
}
