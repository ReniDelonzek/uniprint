import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uniprint/app/shared/models/Impressao.dart';
import 'package:uniprint/app/shared/temas/Tema.dart';
import 'package:uniprint/app/shared/utils/constans.dart';

class DetalhesImpressaoPage extends StatefulWidget {
  final String title;
  Impressao impressao;
  DetalhesImpressaoPage(this.impressao, {Key key, this.title = "DetalhesImpressao"})
      : super(key: key);

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
    return new MaterialApp(
        theme: Tema.getTema(context),
        home: new Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: Text('Detalhes impressão')),
          body: new Builder(
            builder: (builderContext) {
              return Stack(
                children: [
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 15, right: 15),
                        child: Text(
                          widget.impressao.descricao,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: new Text(
                          'Valor Total: ${NumberFormat.simpleCurrency().format(widget.impressao.valorTotal ?? 0)}',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: QrImage(
                          data: widget.impressao.id,
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ),
                      _botaoConfirmarRecebimento(builderContext)
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  )
                ],
              );
            },
          ),
        ));
  }

  Widget _botaoConfirmarRecebimento(BuildContext builderContext) {
    if (widget.impressao.status != Constants.STATUS_IMPRESSAO_RETIRADA) {
      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text('Apresente esse QRCode para retirar'),
            Padding(
              padding: const EdgeInsets.only(top: 45),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new ButtonTheme(
                      height: 45,
                      minWidth: 140,
                      child: RaisedButton(
                        onPressed: () {
                          // Firestore.instance
                          //     .collection("Empresas")
                          //     .document('Uniguacu')
                          //     .collection('Pontos')
                          //     .document(impressao.codPonto)
                          //     .collection('Impressoes')
                          //     .document(impressao.id)
                          //     .updateData({
                          //   'status': Constants.STATUS_IMPRESSAO_CANCELADO
                          // }).then((res) {
                          //   Scaffold.of(builderContext).showSnackBar(SnackBar(
                          //     content:
                          //         Text('Atendimento cancelado com sucesso'),
                          //     duration: Duration(seconds: 3),
                          //   ));
                          //   Future.delayed(Duration(seconds: 1)).then((a) {
                          //     Navigator.of(context).pop();
                          //   });
                          // }).catchError((error) {
                          //   Scaffold.of(builderContext).showSnackBar(SnackBar(
                          //     content: Text(
                          //         'Ops, houve uma falha ao tentar cancelar o atendimento'),
                          //     duration: Duration(seconds: 3),
                          //   ));
                          // });
                        },
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                        child: new Text(
                          "Cancelar",
                          style: new TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: new ButtonTheme(
                        height: 45,
                        minWidth: 150,
                        child: RaisedButton(
                          onPressed: () {
                            // Firestore.instance
                            //     .collection("Empresas")
                            //     .document("Uniguacu")
                            //     .collection("Pontos")
                            //     .document(impressao.codPonto)
                            //     .collection('Impressoes')
                            //     .document(impressao.id)
                            //     .updateData({
                            //   'status': Constants.STATUS_IMPRESSAO_RETIRADA
                            // }).then((value) {
                            //   Scaffold.of(builderContext).showSnackBar(SnackBar(
                            //     content: Text('Confirmado com sucesso'),
                            //     duration: Duration(seconds: 3),
                            //   ));
                            //   Navigator.of(context).pop();
                            // }).catchError((error) {
                            //   print(error);
                            // });
                          },
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.5),
                          ),
                          child: new Text(
                            "Confirmar recebimento",
                            style: new TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Entregue em: ${new DateFormat('dd/MM/yyyy HH:mm:ss').format(widget.impressao.dataEntrega)}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
  }
}
