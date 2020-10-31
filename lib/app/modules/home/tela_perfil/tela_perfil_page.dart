import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniprint/app/app_module.dart';
import 'package:uniprint/app/services/detalhes_usuario_service.dart';
import 'package:uniprint/app/shared/auth/hasura_auth_service.dart';
import 'package:uniprint/app/shared/models/graph/detalhes_usuario.dart';

import '../home_module.dart';

class TelaPerfilPage extends StatefulWidget {
  final String title;
  final FirebaseUser user;
  TelaPerfilPage(this.user, {Key key, this.title = "TelaPerfil"})
      : super(key: key);

  @override
  _TelaPerfilPageState createState() => _TelaPerfilPageState(this.user);
}

class _TelaPerfilPageState extends State<TelaPerfilPage> {
  FirebaseUser user;
  final controllerEmail = TextEditingController();
  final controllerNome = TextEditingController();

  _TelaPerfilPageState(this.user);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
          builder: (build) => Stack(
                children: <Widget>[
                  Container(
                    height: 220,
                    color: Colors.blue,
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 25.0, right: 25, top: 80),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 100,
                                      height: 100,
                                      child: new GestureDetector(
                                        child: Hero(
                                          tag: "imagem_perfil",
                                          child: new CircleAvatar(
                                            backgroundImage: new NetworkImage(user
                                                    ?.photoUrl ??
                                                "https://www.pnglot.com/pngfile/detail/192-1925683_user-icon-png-small.png"),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 3),
                                      child: Text(
                                        user.displayName ?? "",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Text(user.email ?? ""),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 35, left: 15, right: 15),
                                      child: FutureBuilder(
                                        future: HomeModule.to
                                            .getDependency<
                                                DetalhesUsuarioService>()
                                            .recuperarDados(AppModule.to
                                                .getDependency<
                                                    HasuraAuthService>()
                                                .usuario
                                                .codHasura),
                                        builder: (_, snap) {
                                          if (snap.connectionState !=
                                              ConnectionState.done) {
                                            return Container(
                                              height: 50,
                                              child: Text(
                                                  'Carregando detalhes de uso'),
                                            );
                                          } else if (snap.hasError) {
                                            return Container(
                                              height: 50,
                                              child: Text(
                                                  'Ops, houve uma falha ao recuperar os detalhes de uso'),
                                            );
                                          } else {
                                            DetalhesUsuario detalhesUsuario =
                                                snap.data;
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                _getItemDetalhes(
                                                    detalhesUsuario
                                                        .numAtendimentos
                                                        .toString(),
                                                    'Atendimentos'),
                                                VerticalDivider(
                                                  width: 50,
                                                  color: Colors.black26,
                                                ),
                                                _getItemDetalhes(
                                                    detalhesUsuario
                                                        .numImpressoes
                                                        .toString(),
                                                    'Impressões'),
                                                /*VerticalDivider(
                                                  width: 50,
                                                  color: Colors.black26,
                                                ),
                                                _getItemDetalhes(
                                                    '3,50', 'Total gasto'),*/
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          /*Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    decoration: InputDecoration(
                                        hintText: 'Nome', labelText: 'Nome'),
                                    controller: controllerNome,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        hintText: 'Email', labelText: 'Email'),
                                    controller: controllerEmail,
                                  ),
                                ],
                              ),
                            ),
                          )
                        */
                        ],
                      ),
                    ),
                  )
                ],
              )),
    );
  }

  _getItemDetalhes(String data, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(data, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label)
      ],
    );
  }
}
