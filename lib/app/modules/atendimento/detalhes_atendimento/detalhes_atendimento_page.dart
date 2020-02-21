import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:uniprint/app/shared/models/graph/atendimento_g.dart';
import 'package:uniprint/app/shared/models/graph/posicao_atendimento.dart';
import 'package:uniprint/app/shared/network/graph_ql_data.dart';
import 'package:uniprint/app/shared/network/mutations.dart';
import 'package:uniprint/app/shared/network/querys.dart';
import 'package:uniprint/app/shared/utils/constans.dart';
import 'package:uniprint/app/shared/utils/utils_atendimento.dart';
import 'package:uniprint/app/shared/utils/utils_cadastro.dart';
import 'package:uniprint/app/shared/utils/utils_movimentacao.dart';
import 'package:uniprint/app/shared/extensions/date.dart';
import 'package:uniprint/app/shared/widgets/button.dart';
import 'package:uniprint/app/shared/widgets/widgets.dart';

import 'detalhes_atendimento_controller.dart';
import 'detalhes_atendimento_module.dart';

class DetalhesAtendimentoPage extends StatefulWidget {
  final String title;
  final Atendimento atendimento;
  DetalhesAtendimentoPage(this.atendimento,
      {Key key, this.title = "DetalhesAtendimento"})
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
            "Atendimento",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
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
            ),
            Text('Esse é o seu QR de identificação!'),
            Container(
              child: StreamBuilder(
                  stream: GraphQlObject.hasuraConnect.subscription(
                      posicaoAtendimento,
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
            Button("Cancelar", () async {
              ProgressDialog progress = ProgressDialog(context);
              progress.style(message: 'Cancelando atendimento');
              progress.show();

              try {
                var res = await UtilsAtendimento.gerarMovimentacao(
                    Constants.MOV_ATENDIMENTO_CANCELADO_USUARIO,
                    Constants.STATUS_ATENDIMENTO_CANCELADO_USUARIO,
                    widget.atendimento.id,
                    widget.atendimento.usuario.id);
                /*var res = await GraphQlObject.hasuraConnect
                    .mutation(addMovimentacaoAtendimento, variables: {
                  "atendimento_id": widget.atendimento.id,
                  "status": Constants.STATUS_ATENDIMENTO_CANCELADO_USUARIO,
                  "data": DateTime.now().hasuraFormat(),
                  "tipo_movimento": Constants.MOV_ATENDIMENTO_CANCELADO_USUARIO,
                  "usuario_id": widget.atendimento.usuario.id
                });*/
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
            })
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
                    },
                    starCount: 5,
                    rating: _controller.avaliacao,
                    size: 40.0,
                    color: Colors.blue,
                    borderColor: Colors.blue,
                    spacing: 0.0),
              ),
            ),
          ]);
  }

  Widget _getTextPosicao(String text) {
    return Padding(
        child: Text(text,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            )),
        padding: EdgeInsets.all(30));
  }

  _getTimeLine() {
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
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                padding: EdgeInsets.only(top: 16, bottom: 16),
                alignment: Alignment.centerLeft),
            position: position,
            iconBackground:
                UtilsMovimentacao.getColorIcon(mov.movimentacao.tipo),
            icon: Icon(
              UtilsMovimentacao.getIcon(mov.movimentacao.tipo),
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

  // Future<int> getPosicao() async {
  //   Map<String, dynamic> body = {
  //     'pontoID': '${widget.atendimento.ponto}',
  //     'data': '${widget.atendimento.dataSolicitacao.millisecondsSinceEpoch}'
  //   };

  //   var stringJson = json.encode(body);
  //   final response = await http.post(
  //       'https://us-central1-uniprint-uv.cloudfunctions.net/getPosition',
  //       headers: {"content-type": "application/json"},
  //       body: stringJson);

  //   if (response.statusCode == 200) {
  //     int pos = json.decode(response.body)['numAtendimentos'];
  //     print(pos);
  //     return pos;
  //   } else {
  //     //throw Exception('Failed to load post');
  //     return -1;
  //   }
  // }
/*
  Future<String> apiRequest(String url, Map jsonMap) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }
*/
  // Widget _getWidgetPosicao(BuildContext buildContext) {
  //   if (widget.atendimento.status == Constants.STATUS_ATENDIMENTO_SOLICITADO) {
  //     return Column(
  //       children: <Widget>[
  //         new Text("Sua senha de atendimento é:"),
  //         new Padding(padding: EdgeInsets.all(5)),
  //         new Text(widget.atendimento.id.toString(),
  //             style: TextStyle(
  //                 fontSize: 24,
  //                 color: Colors.black,
  //                 fontWeight: FontWeight.bold)),
  //         FutureBuilder(
  //           future: posicao,
  //           builder: (context, snapshot) {
  //             return Text(snapshot.connectionState == ConnectionState.waiting
  //                 ? 'Carregando posição'
  //                 : 'Só mais ${snapshot.data} pessoas na sua frente');
  //           },
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.only(top: 25),
  //           child: new ButtonTheme(
  //               height: 45,
  //               minWidth: 150,
  //               child: RaisedButton(
  //                 onPressed: () {
  //                   // Firestore.instance
  //                   //     .collection("Empresas")
  //                   //     .document('Uniguacu')
  //                   //     .collection('Pontos')
  //                   //     .document(widget.atendimento.codPonto)
  //                   //     .collection('Atendimentos')
  //                   //     .document(widget.atendimento.id)
  //                   //     .updateData({
  //                   //   'status': Constants.STATUS_ATENDIMENTO_CANCELADO_USUARIO
  //                   // }).then((res) {
  //                   //   Scaffold.of(context).showSnackBar(SnackBar(
  //                   //     content: Text('Atendimento cancelado com sucesso'),
  //                   //     duration: Duration(seconds: 3),
  //                   //   ));
  //                   //   Future.delayed(Duration(seconds: 1)).then((a) {
  //                   //     Navigator.of(buildContext).pop();
  //                   //   });
  //                   // }).catchError((error) {
  //                   //   Scaffold.of(context).showSnackBar(SnackBar(
  //                   //     content: Text(
  //                   //         'Ops, houve uma falha ao tentar cancelar o atendimento'),
  //                   //     duration: Duration(seconds: 3),
  //                   //   ));
  //                   // });
  //                 },
  //                 color: Colors.blue,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(22.0),
  //                 ),
  //                 child: new Text(
  //                   "Cancelar",
  //                   style: new TextStyle(
  //                       color: Colors.white, fontWeight: FontWeight.bold),
  //                 ),
  //               )),
  //         ),
  //       ],
  //     );
  //   } else if (widget.atendimento.status ==
  //       Constants.STATUS_ATENDIMENTO_CANCELADO_USUARIO) {
  //     return Hero(
  //       tag: "atendimento_cancelado",
  //       child: Text(
  //         "Você cancelou o atendimento",
  //         style: TextStyle(fontSize: 18),
  //       ),
  //     );
  //   } else if (widget.atendimento.status ==
  //       Constants.STATUS_ATENDIMENTO_CANCELADO_ATENDENTE) {
  //     return Text(
  //       "O atendente cancelou o atendimento",
  //       style: TextStyle(fontSize: 18),
  //     );
  //   } else {
  //     return Text(
  //       "Você foi atendido em ${DateFormat('dd/MM').format(widget.atendimento.data_atendimento)}",
  //       style: TextStyle(fontSize: 18),
  //     );
  //   }
  // }

}
