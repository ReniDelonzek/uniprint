import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uniprint/app/shared/models/graph/atendimento_g.dart';
import 'package:uniprint/app/shared/utils/constans.dart';
import 'package:uniprint/app/shared/extensions/date.dart';
import 'package:uniprint/app/shared/utils/utils_atendimento.dart';

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

  @override
  void initState() {
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
          return new Container(
            child: new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  QrImage(
                    data: widget.atendimento.id.toString(),
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  new Padding(padding: EdgeInsets.all(60)),
                  _getBody()
                ],
              ),
            ),
          );
        }));
  }

  _getBody() {
    return Column(
        children: widget.atendimento.movimentacao_atendimentos
            .map((mov) => Text(
                  '${mov.movimentacao.data.string('dd/MM')}: ${UtilsAtendimento.tipoAtendimento(mov.movimentacao.tipo)}',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ))
            .toList());
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
