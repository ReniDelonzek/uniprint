import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniprint/app/app_module.dart';
import 'package:uniprint/app/modules/home/tela_perfil/tela_perfil_page.dart';
import 'package:uniprint/app/shared/auth/hasura_auth_service.dart';
import 'package:uniprint/app/shared/menu/menu_widget.dart';
import 'package:uniprint/app/shared/models/menu_item.dart';

class MenuDrawerWidget extends StatelessWidget {
  final List<MenuItem> menus;

  const MenuDrawerWidget(this.menus);

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      semanticLabel: 'Abrir menu',
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TelaPerfilPage(AppModule.to
                            .getDependency<HasuraAuthService>()
                            .firebaseUser)));
              },
              child: new UserAccountsDrawerHeader(
                accountName: Text(
                  AppModule.to
                          .getDependency<HasuraAuthService>()
                          .usuario
                          ?.nome ??
                      'Toque aqui para completar seu perfil',
                  style: TextStyle(color: Colors.white),
                ),
                accountEmail: FutureBuilder(
                  future: FirebaseAuth.instance.currentUser(),
                  builder: (_, snap) {
                    if (snap.connectionState != ConnectionState.done ||
                        snap.data == null) {
                      return Text('');
                    }
                    return Text(snap.data.email,
                        style: new TextStyle(color: Colors.white));
                  },
                ),
                currentAccountPicture: Hero(
                  tag: "imagem_perfil",
                  child: new ClipRRect(
                      borderRadius: new BorderRadius.circular(48.0),
                      child: Image.network(
                          AppModule.to
                                  .getDependency<HasuraAuthService>()
                                  .firebaseUser
                                  ?.photoUrl ??
                              'https://img.pngio.com/computer-icons-user-clip-art-transparent-user-icon-png-1742152-user-logo-png-920_641.png',
                          fit: BoxFit.cover)),
                ),
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'imagens/back_drawer.jpg',
                        ))),
              ),
            ),
            MenuWidget(menus)
          ],
        ),
      ),
    );
  }
}
