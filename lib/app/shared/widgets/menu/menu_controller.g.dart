// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MenuController on _MenuBase, Store {
  final _$menuBoxAtom = Atom(name: '_MenuBase.menuBox');

  @override
  Box get menuBox {
    _$menuBoxAtom.context.enforceReadPolicy(_$menuBoxAtom);
    _$menuBoxAtom.reportObserved();
    return super.menuBox;
  }

  @override
  set menuBox(Box value) {
    _$menuBoxAtom.context.conditionallyRunInAction(() {
      super.menuBox = value;
      _$menuBoxAtom.reportChanged();
    }, _$menuBoxAtom, name: '${_$menuBoxAtom.name}_set');
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
