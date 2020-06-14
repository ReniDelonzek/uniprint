import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:uniprint/app/app_module.dart';
import 'package:uniprint/app/modules/home/splash_screen/splash_module.dart';
import 'package:uniprint/app/shared/auth/hasura_auth_service.dart';
import 'package:uniprint/app/shared/db/hive/menu.dart';
import 'package:uniprint/app/shared/models/acao.dart';
import 'package:uniprint/app/shared/models/menu_item.dart';

import 'menu_controller.dart';

class MenuWidget extends StatelessWidget {
  final MenuController menuController = MenuController();
  final List<MenuItem> menus;

  MenuWidget(this.menus) {
    menuController.loadMenus();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) => _getMenu(context));
  }

  Widget _getMenu(BuildContext context) {
    if (!menus.any((element) => element.titulo == 'Sair')) {
      menus.addAll(_getMenusAuth(menuController.menus, context));
    }
    return Column(
      children: _filtrarMenus(menuController.menus, menus, context),
    );
  }

  List<MenuItem> _getMenusAuth(List<Menu> listMenus, BuildContext context) {
    List<MenuItem> menus = List();
    menus.add(MenuItem(
        codSistema: 3,
        icone: Icon(Icons.power_settings_new),
        titulo: 'Sair',
        acao: Acao(funcao: ({data}) async {
          await AppModule.to.getDependency<HasuraAuthService>().logOut();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SplashModule()));
          await menuController.menuBox.clear();
        })));
    return menus;
  }

  Widget _getHeader(String title) {
    return Container(
        padding: EdgeInsets.only(left: 15, top: 10, bottom: 5),
        alignment: Alignment.centerLeft,
        child: Text(title.toUpperCase(),
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)));
  }

  List<Widget> _filtrarMenus(
      List<Menu> listMenus, List<MenuItem> menusItem, BuildContext context) {
    List<Widget> menus = List();

    for (MenuItem menu in menusItem) {
      if (menu.subMenus?.isNotEmpty == true) {
        if (menu.subMenus
            .any((k) => listMenus.any((m) => m.id == k.codSistema))) {
          //existe pelo menos um item, entao retorna o cabeçalho
          menus.add(_getHeader(menu.titulo));
          for (MenuItem subMenu in menu.subMenus) {
            //menus.add(_addItem(subMenu, subMenu.titulo, context));
            for (Menu menuSis in listMenus) {
              if (subMenu.codSistema == menuSis.id) {
                menus.add(_addItem(subMenu, menuSis?.nome, context));
              }
            }
          }
          menus.add(Divider());
        }
      } else {
        for (Menu menuSis in listMenus) {
          if (menu.codSistema == menuSis.id) {
            menus.add(_addItem(menu, menuSis?.nome, context));
          }
        }
      }
    }
    return menus;
  }

  Widget _addItem(MenuItem subMenu, String titulo, BuildContext context) {
    return ListTile(
      trailing: subMenu.icone ?? subMenu.acao?.icon,
      title: Text(titulo ?? subMenu.titulo ?? ''),
      onTap: () {
        if (subMenu.acao.route != null) {
          Navigator.of(context)
              .push(new MaterialPageRoute(builder: subMenu.acao.route));
        }
        if (subMenu.acao.funcao != null) {
          subMenu.acao.funcao(data: context);
        }
      },
    );
  }
}
