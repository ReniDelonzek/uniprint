// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MenuController on _MenuBase, Store {
  final _$personsAtom = Atom(name: '_MenuBase.persons');

  @override
  Box get menuBox {
    _$personsAtom.context.enforceReadPolicy(_$personsAtom);
    _$personsAtom.reportObserved();
    return super.menuBox;
  }

  @override
  set menuBox(Box value) {
    _$personsAtom.context.conditionallyRunInAction(() {
      super.menuBox = value;
      _$personsAtom.reportChanged();
    }, _$personsAtom, name: '${_$personsAtom.name}_set');
  }

  final _$menusAtom = Atom(name: '_MenuBase.menus');

  @override
  ObservableList<Menu> get menus {
    _$menusAtom.context.enforceReadPolicy(_$menusAtom);
    _$menusAtom.reportObserved();
    return super.menus;
  }

  @override
  set menus(ObservableList<Menu> value) {
    _$menusAtom.context.conditionallyRunInAction(() {
      super.menus = value;
      _$menusAtom.reportChanged();
    }, _$menusAtom, name: '${_$menusAtom.name}_set');
  }

  final _$loadMenusAsyncAction = AsyncAction('loadMenus');

  @override
  Future loadMenus() {
    return _$loadMenusAsyncAction.run(() => super.loadMenus());
  }

  final _$getMenusAsyncAction = AsyncAction('getMenus');

  @override
  Future<void> getMenus() {
    return _$getMenusAsyncAction.run(() => super.getMenus());
  }
}
