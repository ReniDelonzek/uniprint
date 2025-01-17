import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:uniprint/app/shared/extensions/date.dart';
import 'package:uniprint/app/shared/models/graph/impressao.dart';
import 'package:uniprint/app/shared/temas/tema.dart';
import 'package:uniprint/app/shared/utils/constans.dart';
import 'package:uniprint/app/shared/utils/utils_cadastro.dart';
import 'package:uniprint/app/shared/utils/utils_impressao.dart';
import 'package:uniprint/app/shared/utils/utils_movimentacao.dart';
import 'package:uniprint/app/shared/widgets/button.dart';

class DetalhesImpressaoPage extends StatefulWidget {
  final String title;
  final Impressao impressao;
  DetalhesImpressaoPage(
    this.impressao, {
    Key key,
    this.title = "Detalhes da Impressão",
  }) : super(key: key);

  @override
  _DetalhesImpressaoPageState createState() => _DetalhesImpressaoPageState();
}

class _DetalhesImpressaoPageState extends State<DetalhesImpressaoPage> {
  _DetalhesImpressaoPageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: new Builder(
        builder: (builderContext) {
          return SingleChildScrollView(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 15, right: 15),
                              child: Text(
                                UtilsImpressao.getResumo(
                                    widget.impressao.arquivo_impressaos),
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  'Valor Total: ${NumberFormat.simpleCurrency().format(widget.impressao.valorTotal ?? 0)}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                _botaoConfirmarRecebimento(builderContext),
                _getTimeLine(),
                //_botaoConfirmarRecebimento(builderContext)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _getTimeLine() {
    TimelineItemPosition position = TimelineItemPosition.left;
    List<TimelineModel> items = widget.impressao.movimentacao_impressaos.map(
      (mov) {
        if (position == TimelineItemPosition.right) {
          position = TimelineItemPosition.left;
        } else {
          position = TimelineItemPosition.right;
        }
        return TimelineModel(
            Container(
                child: Text(
                  '${mov.movimentacao.data.string('dd/MM HH:mm')}\n${UtilsImpressao.getTipoMovimentacao(mov.movimentacao.tipo)}',
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

    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 8, left: 16, right: 16),
      child: Timeline(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: items,
        position: TimelinePosition.Center,
      ),
    );
  }

  Widget _getQr(String qr, BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          alignment: Alignment.center,
          child: QrImage(
            data: qr,
            version: QrVersions.auto,
            size: 200.0,
            foregroundColor: isDarkMode(context) ? Colors.white : Colors.black,
          ),
        ),
        Text('Apresente esse QRCode para retirar'),
        SizedBox(height: 5),
        FlatButton.icon(
            icon: Icon(Icons.done),
            onPressed: () async {
              var res = await UtilsImpressao.gerarMovimentacao(
                  Constants.MOV_IMPRESSAO_RETIRADA,
                  Constants.STATUS_IMPRESSAO_RETIRADA,
                  widget.impressao.id,
                  widget.impressao.usuario.id,
                  context,
                  'Confirmando impressão impressão...');
              if (res) {
                showSnack(
                    context, 'Impressão marcada como retirada com sucesso',
                    dismiss: true);
              } else {
                showSnack(context,
                    'Ops, houve uma falha ao marcar como retirada a impressão');
              }
            },
            label: Text('Eu já retirei o material'))
      ],
    );
  }

  Widget _botaoConfirmarRecebimento(BuildContext context) {
    if (widget.impressao.status != Constants.STATUS_IMPRESSAO_RETIRADA &&
        widget.impressao.status != Constants.STATUS_IMPRESSAO_NEGADA &&
        widget.impressao.status != Constants.STATUS_IMPRESSAO_CANCELADO &&
        widget.impressao.status != Constants.STATUS_IMPRESSAO_AUTORIZADO &&
        widget.impressao.status !=
            Constants.STATUS_IMPRESSAO_AGUARDANDO_RETIRADA) {
      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            //_getQr(widget.impressao.id.toString()),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new FlatButton(
                      child: Text('Cancelar'),
                      onPressed: () async {
                        var res = await UtilsImpressao.gerarMovimentacao(
                            Constants.MOV_IMPRESSAO_CANCELADO,
                            Constants.STATUS_IMPRESSAO_CANCELADO,
                            widget.impressao.id,
                            widget.impressao.usuario.id,
                            context,
                            'Cancelando impressão...');
                        if (res) {
                          showSnack(context, 'Impressão cancelada com sucesso',
                              dismiss: true);
                        } else {
                          showSnack(context,
                              'Ops, houve uma falha ao cancelar a impressão');
                        }
                      }),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: new Button('Confirmar Recebimento', () async {
                      var res = await UtilsImpressao.gerarMovimentacao(
                          Constants.MOV_IMPRESSAO_RETIRADA,
                          Constants.STATUS_IMPRESSAO_RETIRADA,
                          widget.impressao.id,
                          widget.impressao.usuario.id,
                          context,
                          'Confirmando recebimento...');

                      if (res) {
                        showSnack(context, 'Comfirmada com sucesso!');
                      } else {
                        showSnack(context,
                            'Ops, houve uma falha ao confirmar a impressão');
                      }
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (widget.impressao.status ==
        Constants.STATUS_IMPRESSAO_AGUARDANDO_RETIRADA) {
      return _getQr(widget.impressao.id.toString(), context);
    } else
      return Container();
  }
}
