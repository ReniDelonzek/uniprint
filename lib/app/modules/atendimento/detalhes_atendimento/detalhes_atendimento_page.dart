import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:uniprint/app/shared/extensions/date.dart';
import 'package:uniprint/app/shared/models/graph/atendimento_g.dart';
import 'package:uniprint/app/shared/models/graph/posicao_atendimento.dart';
import 'package:uniprint/app/shared/network/graph_ql_data.dart';
import 'package:uniprint/app/shared/network/mutations.dart';
import 'package:uniprint/app/shared/network/querys.dart';
import 'package:uniprint/app/shared/temas/tema.dart';
import 'package:uniprint/app/shared/utils/constans.dart';
import 'package:uniprint/app/shared/utils/utils_atendimento.dart';
import 'package:uniprint/app/shared/utils/utils_cadastro.dart';
import 'package:uniprint/app/shared/utils/utils_movimentacao.dart';
import 'package:uniprint/app/shared/widgets/widgets.dart';

import 'detalhes_atendimento_controller.dart';
import 'detalhes_atendimento_module.dart';

class DetalhesAtendimentoPage extends StatefulWidget {
  final String title;
  final Atendimento atendimento;
  DetalhesAtendimentoPage(this.atendimento,
      {Key key, this.title = "Detalhes do Atendimento"})
      : super(key: key);

  @override
  _DetalhesAtendimentoPageState createState() =>
      _DetalhesAtendimentoPageState();
}

class _DetalhesAtendimentoPageState extends State<DetalhesAtendimentoPage> {
  Future<int> posicao;
  final _controller =
      DetalhesAtendimentoModule.to.bloc<DetalhesAtendimentoController>();

  @override
  void initState() {
    _controller.avaliacao =
        widget.atendimento.nota_atendimento?.toDouble() ?? 4;
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            widget.title,
          ),
        ),
        body: Builder(builder: (context) {
          return new Center(
            child: Padding(
                padding: const EdgeInsets.all(16), child: _getBody(context)),
          );
        }));
  }

  Widget _getBody(BuildContext context) {
    if (widget.atendimento.status == Constants.STATUS_ATENDIMENTO_SOLICITADO) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            QrImage(
              data: widget.atendimento.id.toString(),
              version: QrVersions.auto,
              size: 200.0,
              foregroundColor:
                  isDarkMode(context) ? Colors.white : Colors.black,
            ),
            Text('Esse é o seu QR de identificação!'),
            Container(
              child: StreamBuilder(
                  stream: GraphQlObject.hasuraConnect.subscription(
                      Querys.posicaoAtendimento,
                      variables: {'id': widget.atendimento.id}),
                  builder: (_, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return Text('Carregando posição na fila');
                    }
                    if (snap.hasError || !snap.hasData) {
                      return Text('Ops, houve uma falha ao obter sua posição');
                    }
                    PosicaoAtendimento posicao =
                        PosicaoAtendimento.fromJson(snap.data);
                    if (posicao.data.atendimentoAggregate.aggregate.count ==
                        0) {
                      return _getTextPosicao('Você é o próximo!');
                    }
                    if (posicao.data.atendimentoAggregate.aggregate.count ==
                        1) {
                      return _getTextPosicao(
                          'Só mais ${posicao.data.atendimentoAggregate.aggregate.count} pessoa na fila!');
                    } else
                      return _getTextPosicao(
                          'Mais ${posicao.data.atendimentoAggregate.aggregate.count} pessoas na fila');
                  }),
              height: 100,
            ),
            FlatButton(
              child: Text("Cancelar"),
              onPressed: () async {
                ProgressDialog progress = ProgressDialog(context);
                progress.style(message: 'Cancelando atendimento');
                progress.show();

                try {
                  var res = await UtilsAtendimento.gerarMovimentacao(
                      Constants.MOV_ATENDIMENTO_CANCELADO_USUARIO,
                      Constants.STATUS_ATENDIMENTO_CANCELADO_USUARIO,
                      widget.atendimento.id,
                      widget.atendimento.usuario.id);
                  progress.dismiss();
                  if (res) {
                    showSnack(context, 'Atendimento cancelado com sucesso',
                        dismiss: true);
                  } else {
                    showSnack(context,
                        'Ops, houve uma falha ao tentar cancelar o atendimento');
                  }
                } catch (e) {
                  progress.dismiss();
                  showSnack(context,
                      'Ops, houve uma falha ao tentar cancelar o atendimento');
                  print(e);
                }
              },
            )
          ],
        ),
      );
    } else
      return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: TextTitle('Histórico de movimentação')),
            _getTimeLine(),
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: Observer(
                builder: (_) => SmoothStarRating(
                    allowHalfRating: false,
                    onRatingChanged: (v) {
                      _controller.avaliacao = v;
                      _controller.mostrarBotaoSalvarAvaliacao = true;
                    },
                    starCount: 5,
                    rating: _controller.avaliacao,
                    size: 40.0,
                    color: Colors.blue,
                    borderColor: Colors.blue,
                    spacing: 0.0),
              ),
            ),
            Observer(
              builder: (_) => _controller.mostrarBotaoSalvarAvaliacao
                  ?
                  //so mostra o salvar se a avaliacao for alterada
                  FlatButton(
                      child: Text('Salvar'),
                      onPressed: () async {
                        showSnack(context, 'Cadastrando avaliação...',
                            duration: Duration(seconds: 2));
                        var res = await GraphQlObject.hasuraConnect.mutation(
                            Mutations.cadastroNotaAtendimento,
                            variables: {
                              'id': widget.atendimento.id,
                              'nota_atendimento': _controller.avaliacao.toInt()
                            });
                        if (sucessoMutationAffectRows(
                            res, 'update_atendimento')) {
                          showSnack(
                              context, 'Avaliação cadastrada com sucesso');
                        } else {
                          showSnack(context, 'Ops, houve uma falha ao avaliar');
                        }
                      },
                    )
                  : Container(
                      height: 48,
                      //deixa do mesmo tamanho de um botao, para n ter scrool na hora que o botao aparece
                    ),
            )
          ]);
  }

  Widget _getTextPosicao(String text) {
    return Padding(
        child: Text(text, style: TextStyle(fontSize: 20)),
        padding: EdgeInsets.all(30));
  }

  Widget _getTimeLine() {
    TimelineItemPosition position = TimelineItemPosition.left;
    List<TimelineModel> items =
        widget.atendimento.movimentacao_atendimentos.map(
      (mov) {
        if (position == TimelineItemPosition.right) {
          position = TimelineItemPosition.left;
        } else {
          position = TimelineItemPosition.right;
        }
        return TimelineModel(
            Container(
                child: Text(
                  '${mov.movimentacao.data.string('dd/MM HH:mm')}\n${UtilsAtendimento.tipoAtendimento(mov.movimentacao.tipo)}',
                  style: TextStyle(fontSize: 16),
                ),
                padding: EdgeInsets.only(top: 16, bottom: 16),
                alignment: Alignment.centerLeft),
            position: position,
            iconBackground:
                UtilsMovimentacao.getColorIcon(mov.movimentacao.tipo),
            icon: Icon(
              UtilsMovimentacao.getIconeAtendimento(mov.movimentacao.tipo),
              color: Colors.white,
            ));
      },
    ).toList();

    return Timeline(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: items,
      position: TimelinePosition.Center,
    );
  }
}
