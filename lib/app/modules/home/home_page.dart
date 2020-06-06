import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:uniprint/app/app_module.dart';
import 'package:uniprint/app/modules/atendimento/cadastro_atendimento/cadastro_atendimento_module.dart';
import 'package:uniprint/app/modules/atendimento/detalhes_atendimento/detalhes_atendimento_module.dart';
import 'package:uniprint/app/modules/feedback/feedback_module.dart';
import 'package:uniprint/app/modules/home/home_module.dart';
import 'package:uniprint/app/modules/home/splash_screen/splash_module.dart';
import 'package:uniprint/app/modules/home/tela_perfil/tela_perfil_page.dart';
import 'package:uniprint/app/modules/impressao/cadastro_impressao/cadastro_impressao_module.dart';
import 'package:uniprint/app/modules/impressao/detalhes_impressao/detalhes_impressao_module.dart';
import 'package:uniprint/app/modules/materiais/cadastro_material/cadastro_material_module.dart';
import 'package:uniprint/app/modules/materiais/lista_materiais/lista_materiais_module.dart';
import 'package:uniprint/app/services/sincronizar_dados_service.dart';
import 'package:uniprint/app/shared/auth/hasura_auth_service.dart';
import 'package:uniprint/app/shared/extensions/date.dart';
import 'package:uniprint/app/shared/menu_drawer/menu_drawer_widget.dart';
import 'package:uniprint/app/shared/models/acao.dart';
import 'package:uniprint/app/shared/models/graph/atendimento_g.dart';
import 'package:uniprint/app/shared/models/graph/impressao.dart';
import 'package:uniprint/app/shared/models/graph/movimentacao_g.dart';
import 'package:uniprint/app/shared/models/menu_item.dart';
import 'package:uniprint/app/shared/network/graph_ql_data.dart';
import 'package:uniprint/app/shared/network/querys.dart';
import 'package:uniprint/app/shared/temas/tema.dart';
import 'package:uniprint/app/shared/utils/constans.dart';
import 'package:uniprint/app/shared/utils/utils_atendimento.dart';
import 'package:uniprint/app/shared/utils/utils_cadastro.dart';
import 'package:uniprint/app/shared/utils/utils_impressao.dart';
import 'package:uniprint/app/shared/utils/utils_movimentacao.dart';
import 'package:uniprint/app/shared/widgets/bottom_app_nav.dart';
import 'package:uniprint/app/shared/widgets/fab_multi_icons.dart';
import 'package:uniprint/app/shared/widgets/falha/falha_widget.dart';
import 'package:uniprint/app/shared/widgets/layout.dart';
import 'package:uniprint/app/shared/widgets/lista_vazia/lista_vazia_widget.dart';

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
  BuildContext buildContextScall;

  _HomePageState({this.atendimento});

  void _selectedTab(int index) {
    setState(() {
      _lastSelected = index;
    });
  }

  Future<void> _selectedFab(int index) async {
    switch (index) {
      case 0:
        {
          if (!controller.atendimentos.any((element) =>
              element.status == Constants.STATUS_ATENDIMENTO_SOLICITADO)) {
            controller.exibirFab = false;
            await Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new CadastroAtendimentoModule()));
            controller.exibirFab = true;
          } else {
            showSnack(
                buildContextScall, 'Você já possui um atendimento marcado!');
          }
          break;
        }
      case 1:
        {
          controller.exibirFab = false;
          await Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) =>
                  new CadastroImpressaoModule()));
          controller.exibirFab = true;
          break;
        }
    }
  }

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((user) {
      controller.user = user;
    });

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _atualizarValoresImpressoes();
      if (atendimento != null) {
        //caso tenha vindo a partir de uma notificacao
        controller.exibirFab = false;
        await Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) =>
                new DetalhesAtendimentoModule(atendimento)));
        controller.exibirFab = true;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Observer(
          builder: (_) => new Text(
            "${_getSaudacao()} ${controller.user?.displayName?.split(" ")?.first ?? ""}",
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Builder(builder: (context) {
        buildContextScall = context;
        return (_lastSelected == 0)
            ? _getAtendimentos(context)
            : _getImpressoes(context);
      }),
      drawer: MenuDrawerWidget([
        MenuItem(
            titulo: 'Materiais publicados',
            codSistema: 1,
            icone: new Icon(Icons.school),
            acao: Acao(funcao: ({data}) async {
              controller.exibirFab = false;
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListaMateriaisModule()));
              controller.exibirFab = true;
            })),
        MenuItem(
            titulo: 'FeedBack',
            codSistema: 2,
            icone: new Icon(Icons.favorite),
            acao: Acao(funcao: ({data}) async {
              controller.exibirFab = false;
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FeedbackModule()));
              controller.exibirFab = true;
            }))
      ]),
/*
      drawer: Theme(
          data: Tema.getWhiteTema(context),
          child: new Drawer(
              child: Container(
            child: new Column(children: <Widget>[
              Observer(
                builder: (_) => new UserAccountsDrawerHeader(
                  accountName: new Text(
                    controller.user?.displayName ?? "",
                    style: new TextStyle(color: Colors.white),
                  ),
                  accountEmail: new Text(controller.user?.email ?? "",
                      style: new TextStyle(color: Colors.white)),
                  currentAccountPicture: new GestureDetector(
                    onTap: () async {
                      controller.exibirFab = false;
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TelaPerfilPage(controller.user)));
                      controller.exibirFab = true;
                    },
                    child: Hero(
                      tag: "imagem_perfil",
                      child: new CircleAvatar(
                        backgroundImage: new NetworkImage(controller
                                .user?.photoUrl ??
                            "https://pbs.twimg.com/profile_images/1172678945088688128/VwmaYUyw_400x400.jpg"),
                      ),
                    ),
                  ),
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('imagens/back_drawer.jpg'))),
                ),
              ),
              new ListTile(
                  title: new Text("Materiais publicados"),
                  trailing: new Icon(Icons.school),
                  onTap: () async {
                    controller.exibirFab = false;
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListaMateriaisModule()));
                    controller.exibirFab = true;
                  }),
              _cadastroMaterial(),
              new ListTile(
                  title: new Text("FeedBack"),
                  trailing: new Icon(Icons.favorite),
                  onTap: () async {
                    controller.exibirFab = false;
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FeedbackModule()));
                    controller.exibirFab = true;
                  }),
              new Divider(),
              new ListTile(
                  title: new Text("Sair"),
                  trailing: new Icon(Icons.power_settings_new),
                  onTap: () async {
                    await AppModule.to
                        .getDependency<HasuraAuthService>()
                        .logOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SplashModule()));
                  }),
            ]),
          ))),
     */
      bottomNavigationBar: FABBottomAppBar(
        centerItemText: '',
        selectedColor: Colors.blue,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _selectedTab,
        items: [
          FABBottomAppBarItem(iconData: Icons.group_work, text: 'Atendimentos'),
          FABBottomAppBarItem(iconData: Icons.layers, text: 'Impressões'),
        ],
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(context),
    );
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

  Widget _getAtendimentos(BuildContext context) {
    return StreamBuilder(
      stream: GraphQlObject.hasuraConnect
          .subscription(Querys.getAtendimentos, variables: {
        "usuario_id":
            AppModule.to.getDependency<HasuraAuthService>().usuario.codHasura
      }),
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snap.hasError) {
          return Center(
            child: FalhaWidget('Houve uma falha ao recuperar os dados'),
          );
        }
        if (!snap.hasData || snap.data['data']['atendimento'].isEmpty) {
          return ListaVaziaWidget(
              'Nenhum atendimento na lista',
              "Agende seu primeiro atendimento clicando no '+'",
              'imagens/reception.png');
        } else {
          List<Atendimento> a = List<Atendimento>.from(snap.data['data']
                  ['atendimento']
              .map((a) => Atendimento.fromMap(a))).toList();
          controller.atendimentos.clear();
          controller.atendimentos.addAll(a);
          return ListView.builder(
            itemCount: controller.atendimentos.length,
            itemBuilder: (_, pos) {
              return InkWell(
                  onTap: () async {
                    controller.exibirFab = false;
                    await Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new DetalhesAtendimentoModule(
                                controller.atendimentos[pos])));
                    controller.exibirFab = true;
                  },
                  child: new Padding(
                    padding: EdgeInsets.all(15.0),
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Atendimento: ${controller.atendimentos[pos].id}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          _getMovimentacoesAtendimento(
                              controller.atendimentos[pos])
                        ]),
                  ));
            },
          );
        }
      },
    );
  }

  Widget _getImpressoes(BuildContext context) {
    return StreamBuilder(
        stream: GraphQlObject.hasuraConnect
            .subscription(Querys.getImpressoes, variables: {
          "usuario_id":
              AppModule.to.getDependency<HasuraAuthService>().usuario.codHasura
        }),
        builder: (_, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snap.hasError) {
            return Center(
              child: FalhaWidget('Houve uma falha ao recuperar os dados'),
            );
          }
          if (!snap.hasData || snap.data['data']['impressao'].isEmpty) {
            return ListaVaziaWidget(
                'Nenhuma impressão na lista',
                "Solicite sua primeira impressão no botão '+'",
                'imagens/printer_icon.png');
          } else {
            List<Impressao> a = List<Impressao>.from(snap.data['data']
                    ['impressao']
                .map((a) => Impressao.fromMap(a))).toList();
            controller.impressoes.clear();
            controller.impressoes.addAll(a);
            return ListView.builder(
              itemCount: controller.impressoes.length,
              itemBuilder: (_, pos) {
                return _getItensCardImpressao(controller.impressoes[pos]);
              },
            );
          }
        });
  }

  Widget _getItensCardImpressao(Impressao impressao) {
    return Card(
        child: InkWell(
      onTap: () async {
        controller.exibirFab = false;
        await Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) =>
                new DetalhesImpressaoModule(impressao)));
        controller.exibirFab = true;
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                UtilsImpressao.getStatusImpressao(impressao.status),
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(UtilsImpressao.getResumo(impressao.arquivo_impressaos)),
              Text(
                (impressao.comentario == null || impressao.comentario.isEmpty)
                    ? 'Nenhum comentário extra'
                    : impressao.comentario,
              ),
              _getMovimentacoesImpressao(impressao)
              //new Text(NumberFormat.simpleCurrency().format(impressao.valorTotal ?? 0))
            ]),
      ),
    ));
  }

  Widget _getMovimentacoesImpressao(Impressao impressao) {
    Movimentacao mov = impressao.movimentacao_impressaos?.first?.movimentacao;
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(UtilsImpressao.getIconeFromStatus(impressao.status)),
          ),
          Expanded(
            child: Text(
                '${mov?.data?.string('dd/MM HH:mm:ss') ?? ''}: ${UtilsImpressao.getStatusImpressao(impressao.status)}'),
          )
        ],
      ),
    );
  }

  Widget _getMovimentacoesAtendimento(Atendimento atendimento) {
    Movimentacao mov =
        atendimento.movimentacao_atendimentos?.last?.movimentacao;
    return Container(
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Icon(
                UtilsMovimentacao.getIconeAtendimento((atendimento.status))),
          ),
          Expanded(
            child: Text(
                '${mov?.data?.string('dd/MM HH:mm:ss') ?? ''}: ${UtilsAtendimento.tipoAtendimento(mov.tipo)}'),
          )
        ],
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    final icons = [
      ItemFabWith(
          icon: Icons.add,
          title: 'Impressão arquivos',
          heroTag: 'add_atendimento',
          color: Colors.white),
      ItemFabWith(
          icon: Icons.print, title: 'Senha Atendimento', color: Colors.white),
      //ItemFabWith(icon: Icons.people, title: 'Material Aula')
    ];
    return Observer(
      builder: (_) => AnchoredOverlay(
        showOverlay: controller.exibirFab,
        overlayBuilder: (context, offset) {
          return CenterAbout(
            position: Offset(offset.dx, offset.dy - icons.length * 35.0),
            child: FabWithIcons(
              icons: icons,
              onIconTapped: _selectedFab,
            ),
          );
        },
        child: FloatingActionButton(
          heroTag: 'aaa',
          onPressed: () {},
          tooltip: 'Increment',
          child: Icon(Icons.add),
          elevation: 5.0,
        ),
      ),
    );
  }

  Widget _cadastroMaterial() {
    if (AppModule.to.getDependency<HasuraAuthService>().usuario.codProfessor !=
        null) {
      return new ListTile(
          title: new Text("Cadastrar Material (Professor)"),
          trailing: new Icon(Icons.list),
          onTap: () async {
            controller.exibirFab = false;
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CadastroMaterialModule()));
            controller.exibirFab = true;
          });
    } else {
      return Container();
    }
  }

  _atualizarValoresImpressoes() {
    //compute(sincronizarDados, '');
    sincronizarDados('');
  }
}

sincronizarDados(String s) {
  SincronizarDadosService().sincronizar('');
}
