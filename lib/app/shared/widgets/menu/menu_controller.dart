import 'dart:async';

import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:uniprint/app/app_module.dart';
import 'package:uniprint/app/shared/auth/hasura_auth_service.dart';
import 'package:uniprint/app/shared/db/hive/menu.dart';
import 'package:uniprint/app/shared/db/hive/utils_hive_service.dart';
import 'package:uniprint/app/shared/network/graph_ql_data.dart';
import 'package:uniprint/app/shared/network/querys.dart';
import 'package:uniprint/app/shared/utils/utils_sentry.dart';

part 'menu_controller.g.dart';

class MenuController = _MenuBase with _$MenuController;

abstract class _MenuBase with Store {
  @observable
  Box persons;
  @observable
  ObservableList<Menu> menus = ObservableList();

  _MenuBase();

  @action
  loadMenus() async {
    await _init();
    for (var menu in persons.values) {
      menus.add(menu);
    }
  }

  _init() async {
    persons =
        await AppModule.to.getDependency<UtilsHiveService>().getBox('menu');
    getMenus();
    return persons;
  }

  @action
  Future<void> getMenus() async {
    try {
      var res = await GraphQlObject.hasuraConnect
          .query(Querys.getMenus, variables: {
        'usuario_id':
            AppModule.to.getDependency<HasuraAuthService>().usuario?.codHasura
      });
      if (res != null && res.containsKey('data')) {
        await persons.clear();
        for (var map in res['data']['menu']) {
          Menu menu = Menu.fromMap(map);
          await persons.put(menu.id, menu);
        }

        menus.clear();
        for (var menu in persons.values) {
          menus.add(menu);
        }
      }
    } catch (error, stackTrace) {
      UtilsSentry.reportError(error, stackTrace);
    }

    return menus;
  }
}
