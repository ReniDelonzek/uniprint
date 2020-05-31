// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cadastro_material_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CadastroMaterialController on _CadastroMaterialBase, Store {
  final _$quantidadeAtom = Atom(name: '_CadastroMaterialBase.quantidade');

  @override
  int get quantidade {
    _$quantidadeAtom.context.enforceReadPolicy(_$quantidadeAtom);
    _$quantidadeAtom.reportObserved();
    return super.quantidade;
  }

  @override
  set quantidade(int value) {
    _$quantidadeAtom.context.conditionallyRunInAction(() {
      super.quantidade = value;
      _$quantidadeAtom.reportChanged();
    }, _$quantidadeAtom, name: '${_$quantidadeAtom.name}_set');
  }

  final _$coloridoAtom = Atom(name: '_CadastroMaterialBase.colorido');

  @override
  bool get colorido {
    _$coloridoAtom.context.enforceReadPolicy(_$coloridoAtom);
    _$coloridoAtom.reportObserved();
    return super.colorido;
  }

  @override
  set colorido(bool value) {
    _$coloridoAtom.context.conditionallyRunInAction(() {
      super.colorido = value;
      _$coloridoAtom.reportChanged();
    }, _$coloridoAtom, name: '${_$coloridoAtom.name}_set');
  }

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

  final _$arquivosAtom = Atom(name: '_CadastroMaterialBase.arquivos');

  @override
  ObservableList<ArquivoMaterial> get arquivos {
    _$arquivosAtom.context.enforceReadPolicy(_$arquivosAtom);
    _$arquivosAtom.reportObserved();
    return super.arquivos;
  }

  @override
  set arquivos(ObservableList<ArquivoMaterial> value) {
    _$arquivosAtom.context.conditionallyRunInAction(() {
      super.arquivos = value;
      _$arquivosAtom.reportChanged();
    }, _$arquivosAtom, name: '${_$arquivosAtom.name}_set');
  }
}
