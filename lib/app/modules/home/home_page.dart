import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:intl/intl.dart';
import 'package:uniprint/app/modules/atendimento/cadastro_atendimento/cadastro_atendimento_module.dart';
import 'package:uniprint/app/modules/atendimento/detalhes_atendimento/detalhes_atendimento_module.dart';
import 'package:uniprint/app/modules/feedback/feedback_module.dart';
import 'package:uniprint/app/modules/home/home_module.dart';
import 'package:uniprint/app/modules/home/login_social/login_social_page.dart';
import 'package:uniprint/app/modules/home/tela_perfil/tela_perfil_page.dart';
import 'package:uniprint/app/modules/impressao/cadastro_impressao/cadastro_impressao_module.dart';
import 'package:uniprint/app/modules/impressao/detalhes_impressao/detalhes_impressao_module.dart';
import 'package:uniprint/app/modules/materiais/cadastro_material/cadastro_material_module.dart';

import 'package:uniprint/app/shared/models/Impressao.dart';
import 'package:uniprint/app/shared/models/LocalAtendimento.dart';
import 'package:uniprint/app/shared/models/graph/atendimento_g.dart';
import 'package:uniprint/app/shared/models/graph/movimentacao_g.dart';
import 'package:uniprint/app/shared/network/graph_ql_data.dart';
import 'package:uniprint/app/shared/network/querys.dart';
import 'package:uniprint/app/shared/temas/Tema.dart';
import 'package:uniprint/app/shared/utils/constans.dart';
import 'package:uniprint/app/shared/utils/utils_atendimento.dart';
import 'package:uniprint/app/shared/utils/utils_login.dart';
import 'package:uniprint/app/shared/widgets/bottom_app_nav.dart';
import 'package:uniprint/app/shared/widgets/fab_multi_icons.dart';
import 'package:uniprint/app/shared/extensions/date.dart';

import 'home_controller.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeModule.to.bloc<HomeController>();

  Atendimento atendimento;
  int _lastSelected = 0;
  bool atendimentoPendente = false;

  //caso haja um atendimento pendente, nao deixa criar outro
  BuildContext buildContextScall;
  bool exibirFab = true;

  _HomePageState({this.atendimento});

  void _selectedTab(int index) {
    setState(() {
      _lastSelected = index;
    });
  }

  void _selectedFab(int index) {
    switch (index) {
      case 0:
        {
          if (!atendimentoPendente) {
            /*Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new CadastroAtendimento()));*/
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new CadastroAtendimentoModule()));
          } else {
            Scaffold.of(buildContextScall).showSnackBar(SnackBar(
              content: Text('Você já possui um atendimento marcado!'),
              duration: Duration(seconds: 3),
            ));
          }
          break;
        }
      case 1:
        {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) =>
                  new CadastroImpressaoModule()));
          break;
        }
      case 2:
        {
          // Navigator.of(context).push(new MaterialPageRoute(
          //     builder: (BuildContext context) => new ListaAtendente()));
          // break;
        }
    }
    //  });
  }

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((user) {
      controller.user = user;
    });
    if (atendimento != null) {
      //case tenha vindo a partir de uma notificacao
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        setState(() {
          exibirFab = false;
        });
        await Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) =>
                new DetalhesAtendimentoModule(atendimento)));
        setState(() {
          exibirFab = true;
        });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getAtendimentosHasura();
    atendimentoPendente = false;
    return Builder(builder: ((context) {
      return new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: new Text(
            "${_getSaudacao()} ${controller.user?.displayName?.split(" ")?.first ?? ""}",
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Builder(builder: (context) {
          buildContextScall = context;
          return (_lastSelected == 0)
              ? _getAtendimentos(context)
              : _getImpressoes(context);
        }),
        drawer: Theme(
            data: Theme.of(context).copyWith(
              // Set the transparency here
              canvasColor: Colors
                  .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
            ),
            child: new Drawer(
                child: Container(
              color: Colors.white,
              child: new Column(children: <Widget>[
                new UserAccountsDrawerHeader(
                  accountName: new Text(
                    controller.user?.displayName ?? "",
                    style: new TextStyle(color: Colors.white),
                  ),
                  accountEmail: new Text(controller.user?.email ?? "",
                      style: new TextStyle(color: Colors.white)),
                  currentAccountPicture: new GestureDetector(
                    onTap: () async {
                      setState(() {
                        exibirFab = false;
                      });
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TelaPerfilPage(controller.user)));
                      setState(() {
                        exibirFab = true;
                      });
                    },
                    child: Hero(
                      tag: "imagem_perfil",
                      child: new CircleAvatar(
                        backgroundImage: new NetworkImage(controller
                                .user?.photoUrl ??
                            "https://www.pnglot.com/pngfile/detail/192-1925683_user-icon-png-small.png"),
                      ),
                    ),
                  ),
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('imagens/back_drawer.jpg'))),
                ),
                new ListTile(
                    title: new Text("Materiais publicados"),
                    trailing: new Icon(Icons.school),
                    onTap: () async {
                      // setState(() {
                      //   exibirFab = false;
                      // });
                      // await Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ListaMateriais()));
                      // setState(() {
                      //   exibirFab = true;
                      // });
                    }),
                _cadastroMaterial(),
                new ListTile(
                    title: new Text("FeedBack"),
                    trailing: new Icon(Icons.favorite),
                    onTap: () async {
                      setState(() {
                        exibirFab = false;
                      });
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FeedbackModule()));
                      setState(() {
                        exibirFab = true;
                      });
                    }),
                new Divider(),
                new ListTile(
                    title: new Text("Sair"),
                    trailing: new Icon(Icons.power_settings_new),
                    onTap: () {
                      deslogar();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginSocialPage()));
                    }),
              ]),
            ))),
        bottomNavigationBar: FABBottomAppBar(
          centerItemText: '',
          color: Colors.grey,
          selectedColor: Colors.blue,
          notchedShape: CircularNotchedRectangle(),
          onTabSelected: _selectedTab,
          items: [
            FABBottomAppBarItem(
                iconData: Icons.group_work, text: 'Atendimentos'),
            FABBottomAppBarItem(iconData: Icons.layers, text: 'Impressões'),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _buildFab(context),
      );
    }));
  }

  String _getSaudacao() {
    int hora = TimeOfDay.now().hour;
    if (hora < 6 || hora > 18) {
      return 'Boa Noite';
    } else if (hora > 12) {
      return 'Boa tarde';
    } else {
      return 'Bom Dia';
    }
  }

  _getAtendimentosHasura() async {
    Snapshot snapshot =
        GraphQlObject.hasuraConnect.subscription(getAtendimentos);
    //     .convert((data) {
    //   return data['data']['atendimento'].map((a) => Atendimento.fromJson(a));
    // }, cachePersist: (data) {
    //   return data.map((a) => a.toJson()).toList();
    // });
    snapshot.listen((data) {
      List<Atendimento> a = List<Atendimento>.from(
              data['data']['atendimento'].map((a) => Atendimento.fromJson(a)))
          .toList();
      controller.atendimentos.clear();
      controller.atendimentos.addAll(a);
    });
  }

  Widget _getAtendimentos(BuildContext context) {
    return Observer(
      builder: (_) => ListView.builder(
        itemCount: controller.atendimentos.length,
        itemBuilder: (_, pos) {
          return InkWell(
              onTap: () async {
                setState(() {
                  exibirFab = false;
                });
                await Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new DetalhesAtendimentoModule(
                            controller.atendimentos[pos])));
                setState(() {
                  exibirFab = true;
                });
              },
              child: new Padding(
                padding: EdgeInsets.all(15.0),
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _getItemCardAtendimento(controller.atendimentos[pos])
                    ]),
              ));
        },
      ),
    );
    // List<Widget> createChildren(AsyncSnapshot<QuerySnapshot> s) {
    //   return s.data.documents.map(
    //     (document) {
    //       Atendimento atendimento = Atendimento.fromJson(document.data);
    //       atendimento.id = document.documentID;
    //       if (atendimento.status == Constants.STATUS_ATENDIMENTO_SOLICITADO) {
    //         atendimentoPendente = true;
    //       }
    //       return InkWell(
    //           onTap: () async {
    //             setState(() {
    //               exibirFab = false;
    //             });
    //             await Navigator.of(context).push(new MaterialPageRoute(
    //                 builder: (BuildContext context) =>
    //                     new DetalhesAtendimentoModule(
    //                         /*atendimento: atendimento*/)));
    //             setState(() {
    //               exibirFab = true;
    //             });
    //           },
    //           child: new Padding(
    //             padding: EdgeInsets.all(15.0),
    //             child: new Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: <Widget>[_getItemCardAtendimento(atendimento)]),
    //           ));
    //     },
    //     //),
    //   ).toList();
    // }

    // if (controller.user != null) {
    //   return StreamBuilder<QuerySnapshot>(
    //     stream: Firestore.instance
    //         .collectionGroup('Atendimentos')
    //         .where("codSolicitante", isEqualTo: "${controller.user?.uid ?? 0}")
    //         .orderBy("dataSolicitacao", descending: true)
    //         .snapshots(),
    //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //       if (snapshot.hasError) return new Text('${snapshot.error}');
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.waiting:
    //           return new Center(child: new RefreshProgressIndicator());
    //         default:
    //           if (snapshot?.data?.documents?.isEmpty ?? true)
    //             return Center(
    //                 child: new Text('Solicite seu primeiro atendimento'));
    //           else
    //             return new ListView(children: createChildren(snapshot));
    //       }
    //     },
    //   );
    // } else
    //   return Text('rere');
  }

  Future<Widget> _getImpressoes(BuildContext context) async {
    List<Widget> createChildren(AsyncSnapshot<QuerySnapshot> s) {
      return s.data.documents.map(
        (document) {
          Impressao impressao = Impressao.fromJson(document.data);
          impressao.id = document.documentID;
          return new Card(
            elevation: 2,
            child: InkWell(
                onTap: () async {
                  setState(() {
                    exibirFab = false;
                  });
                  await Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new DetalhesImpressaoModule(impressao)));
                  setState(() {
                    exibirFab = true;
                  });
                },
                child: new Padding(
                  padding: EdgeInsets.all(15.0),
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[_getItensCardImpressao(impressao)]),
                )),
          );
        },
      ).toList();
    }

    if (controller.user != null) {
      return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collectionGroup('Impressoes')
            .where("codSolicitante", isEqualTo: "${controller.user?.uid ?? 0}")
            .orderBy("dataSolicitacao", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Center(child: new RefreshProgressIndicator());
            default:
              if (snapshot?.data?.documents?.isEmpty ?? true)
                return Center(child: new Text('Nenhuma impressão cadastrada'));
              else
                return new ListView(children: createChildren(snapshot));
          }
        },
      );
    }
  }

  //status
  //data de impressao
  //resumo arquivos
  //valor total da impressao
  //aprovado por

  Widget _getItensCardImpressao(Impressao impressao) {
    return new Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      new Text(
        getStatusImpressao(impressao.status),
        style: new TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      _dataImpressao(impressao),
      new Text(NumberFormat.simpleCurrency().format(impressao.valorTotal ?? 0))
    ]);
  }

  Widget _getItemCardAtendimento(Atendimento atendimento) {
    Movimentacao mov =
        atendimento.movimentacao_atendimentos?.first?.movimentacao;
    return new Column(
      children: <Widget>[
        Text(
            '${mov?.data?.string('dd/MM') ?? ''}: ${UtilsAtendimento.tipoAtendimento(atendimento.status)}')
      ],
    );

    if (atendimento.status == Constants.STATUS_ATENDIMENTO_SOLICITADO) {
      return new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
                'Agendando em: ${new DateFormat("dd/MM - HH:mm").format((atendimento.data_solicitacao)) ?? ''}'),
            new Text(getLocalAtendimento((atendimento.ponto_atendimento_id)))
          ]);
    } else if (atendimento.status ==
        Constants.STATUS_ATENDIMENTO_CANCELADO_ATENDENTE) {
      return new Column(
        children: <Widget>[
          new Text('O atendente cancelou o atendimento'),
          new Text(
              'Agendando em: ${new DateFormat("dd/MM - HH:mm").format((atendimento.data_solicitacao)) ?? ''}'),
        ],
      );
    } else if (atendimento.status ==
        Constants.STATUS_ATENDIMENTO_CANCELADO_USUARIO) {
      return new Column(
        children: <Widget>[
          new Text('Você cancelou o atendimento'),
          new Text(
              'Agendando em: ${new DateFormat("dd/MM - HH:mm").format((atendimento.data_solicitacao)) ?? ''}'),
        ],
      );
    } else {
      return new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text('Data do atendimento: ' +
                    new DateFormat("dd/MM - HH:mm")
                        .format(atendimento.data_solicitacao) ??
                ''),
            getSatisfacao(1),
          ]);
    }
  }

  String getStatusAtendimento(int status, DateTime dataAtendimento) {
    switch (status) {
      case Constants.STATUS_ATENDIMENTO_SOLICITADO:
        return "Atendimento solicitado";
      case Constants.STATUS_ATENDIMENTO_EM_ATENDIMENTO:
        return "Atendimento em andamento";
      case Constants.STATUS_ATENDIMENTO_ATENDIDO:
        return "Você foi atendido em ${new DateFormat("dd/MM HH:mm").format(dataAtendimento ?? DateTime.now())}";
      case Constants.STATUS_ATENDIMENTO_CANCELADO_USUARIO:
        return "Atendimento cancelado pelo usuario";
      case Constants.STATUS_ATENDIMENTO_CANCELADO_ATENDENTE:
        return "Atendimento cancelado pelo atendente";

      default:
        return '';
    }
  }

  String getStatusImpressao(int status) {
    switch (status) {
      case Constants.STATUS_IMPRESSAO_SOLICITADO:
        return "Impressão solicitada";
      case Constants.STATUS_IMPRESSAO_AUTORIZADO:
        return "Arquivo Impresso";
      case Constants.STATUS_IMPRESSAO_AGUARDANDO_RETIRADA:
        return "Suas folhas estão aguardando retirada";
      case Constants.STATUS_IMPRESSAO_RETIRADA:
        return "Impressão finalizada";
      case Constants.STATUS_IMPRESSAO_CANCELADO:
        return "Impressão cancelada";
      case Constants.STATUS_IMPRESSAO_NEGADA:
        return "Impressão negada";

      default:
        return '';
    }
  }

  Widget getSatisfacao(int satisfacao) {
    switch (satisfacao) {
      case 0: //ruim
        return new Icon(Icons.sentiment_neutral, size: 15);
      case 1:
        return new Icon(Icons.sentiment_satisfied, size: 15);
      case 2:
        return new Icon(Icons.sentiment_very_satisfied, size: 15);
      default:
        return new Icon(Icons.sentiment_satisfied, size: 15);
    }
  }

  Widget _buildFab(BuildContext context) {
    final icons = [
      ItemFabWith(icon: Icons.add, title: 'Impressão arquivos'),
      ItemFabWith(icon: Icons.print, title: 'Senha Atendimento'),
      //ItemFabWith(icon: Icons.people, title: 'Material Aula')
    ];
    // return AnchoredOverlay(
    //   showOverlay: exibirFab,
    //   overlayBuilder: (context, offset) {
    //     return CenterAbout(
    //       position: Offset(offset.dx, offset.dy - icons.length * 35.0),
    //       child: FabWithIcons(
    //         icons: icons,
    //         onIconTapped: _selectedFab,
    //       ),
    //     );
    //   },
    //child:
    return FloatingActionButton(
      heroTag: 'aaa',
      onPressed: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) =>
                new CadastroAtendimentoModule()));
      },
      tooltip: 'Increment',
      child: Icon(Icons.add),
      elevation: 5.0,
      //),
    );
  }

  Widget _dataImpressao(Impressao impressao) {
    if (impressao.status > Constants.STATUS_IMPRESSAO_SOLICITADO)
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text('Data da impressão ' +
              new DateFormat('dd/MM/yy - HH:mm')
                  .format(impressao.dataImpressao)),
          new Text(impressao.descricao ?? ''),
        ],
      );
    return new Text(impressao.descricao ?? '');
  }

  _cadastroMaterial() {
    return new ListTile(
        title: new Text("Cadastrar Material (Professor)"),
        trailing: new Icon(Icons.list),
        onTap: () async {
          setState(() {
            exibirFab = false;
          });
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CadastroMaterialModule()));
          setState(() {
            exibirFab = true;
          });
        });
  }
}
