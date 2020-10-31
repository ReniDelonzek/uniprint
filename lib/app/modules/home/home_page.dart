import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:uniprint/app/app_module.dart';
import 'package:uniprint/app/modules/atendimento/cadastro_atendimento/cadastro_atendimento_module.dart';
import 'package:uniprint/app/modules/atendimento/detalhes_atendimento/detalhes_atendimento_module.dart';
import 'package:uniprint/app/modules/feedback/feedback_module.dart';
import 'package:uniprint/app/modules/home/home_module.dart';
import 'package:uniprint/app/modules/home/splash_screen/splash_module.dart';
import 'package:uniprint/app/modules/impressao/cadastro_impressao/cadastro_impressao_module.dart';
import 'package:uniprint/app/modules/impressao/detalhes_impressao/detalhes_impressao_module.dart';
import 'package:uniprint/app/modules/materiais/cadastro_material/cadastro_material_module.dart';
import 'package:uniprint/app/modules/materiais/lista_materiais/lista_materiais_module.dart';
import 'package:uniprint/app/services/sincronizar_dados_service.dart';
import 'package:uniprint/app/shared/auth/hasura_auth_service.dart';
import 'package:uniprint/app/shared/extensions/date.dart';
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
import 'package:uniprint/app/shared/widgets/falha/falha_widget.dart';
import 'package:uniprint/app/shared/widgets/lista_vazia/lista_vazia_widget.dart';
import 'package:uniprint/app/shared/widgets/menu_drawer/menu_drawer_widget.dart';

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
  BuildContext buildContextScall;

  _HomePageState({this.atendimento});

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
        return Observer(
            builder: (context) => (controller.lastSelected == 0)
                ? _getAtendimentos(context)
                : _getImpressoes(context));
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
            })),
        MenuItem(
            titulo: 'Cadastrar Material',
            codSistema: 4,
            icone: Icon(Icons.add_box),
            acao: Acao(funcao: ({data}) async {
              controller.exibirFab = false;
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CadastroMaterialModule()));
              controller.exibirFab = true;
            })),
        MenuItem(
            codSistema: 3,
            icone: Icon(Icons.power_settings_new),
            titulo: 'Sair',
            acao: Acao(funcao: ({data}) async {
              await AppModule.to.getDependency<HasuraAuthService>().logOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SplashModule()));
            }))
      ]),
      bottomNavigationBar: CurvedNavigationBar(
        key: controller.navigationKey,
        color: getCorPadrao(),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: getCorPadrao(),
        height: 60,
        items: [
          Icon(
            Icons.group_work,
            color: Colors.white,
          ),
          Icon(
            Icons.layers,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          controller.lastSelected = index;
        },
        animationDuration: Duration(milliseconds: 400),
      ),
      floatingActionButton: builFab2(context),
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
    if (atendimento.movimentacao_atendimentos?.isNotEmpty == false) {
      return Container();
    }
    Movimentacao mov =
        atendimento.movimentacao_atendimentos?.last?.movimentacao;
    return Container(
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Icon(
              UtilsMovimentacao.getIconeAtendimento((atendimento.status)),
              color: UtilsMovimentacao.getColorIcon(atendimento.status),
            ),
          ),
          Expanded(
            child: Text(
                '${mov?.data?.string('dd/MM HH:mm:ss') ?? ''}: ${UtilsAtendimento.tipoAtendimento(mov.tipo)}'),
          )
        ],
      ),
    );
  }

  Widget builFab2(BuildContext context) {
    return SpeedDial(
      child: Icon(Icons.add),
      labelsStyle: TextStyle(color: Colors.black),
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
          child: Icon(Icons.add),
          label: 'Senha Atendimento',
          onPressed: () async {
            if (!controller.atendimentos.any((element) =>
                element.status == Constants.STATUS_ATENDIMENTO_SOLICITADO)) {
              await Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new CadastroAtendimentoModule()));
            } else {
              showSnack(
                  buildContextScall, 'Você já possui um atendimento marcado!');
            }
          },
          closeSpeedDialOnPressed: true,
        ),
        SpeedDialChild(
          child: Icon(Icons.print),
          label: 'Impressão arquivos',
          onPressed: () async {
            await Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new CadastroImpressaoModule()));
          },
        ),
        //  Your other SpeeDialChildren go here.
      ],
    );
  }

  _atualizarValoresImpressoes() {
    //compute(sincronizarDados, '');
    sincronizarDados('');
  }
}

sincronizarDados(String s) {
  SincronizarDadosService().sincronizar('');
}
