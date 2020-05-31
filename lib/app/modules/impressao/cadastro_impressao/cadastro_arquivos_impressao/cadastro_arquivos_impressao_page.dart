import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:uniprint/app/modules/impressao/cadastro_impressao/cadastro_arquivos_impressao/cadastro_arquivos_impressao_controller.dart';
import 'package:uniprint/app/shared/db/hive/tipo_folha.dart';
import 'package:uniprint/app/shared/models/graph/arquivo_impressao.dart';
import 'package:uniprint/app/shared/widgets/falha/falha_widget.dart';
import 'package:uniprint/app/shared/widgets/selecionar_quantidade/selecionar_quantidade_widget.dart';
import 'package:uniprint/app/shared/widgets/tipo_folha/tipo_folha_controller.dart';
import 'package:uniprint/app/shared/widgets/tipo_folha/tipo_folha_widget.dart';

import 'cadastro_arquivos_impressao_module.dart';

class CadastroArquivosImpressaoPage extends StatefulWidget {
  final String title;
  final List<ArquivoImpressao> arquivos;
  const CadastroArquivosImpressaoPage(
      {Key key,
      this.title = "Cadastro Arquivos Impressao",
      @required this.arquivos})
      : super(key: key);

  @override
  _CadastroArquivosImpressaoPageState createState() =>
      _CadastroArquivosImpressaoPageState(arquivos);
}

class _CadastroArquivosImpressaoPageState
    extends State<CadastroArquivosImpressaoPage> {
  final controller = CadastroArquivosImpressaoModule.to
      .bloc<CadastroArquivosImpressaoController>();

  bool _visibility = true;
  List<TipoFolha> tamanhosFolha = List();

  _CadastroArquivosImpressaoPageState(List<ArquivoImpressao> arq) {
    controller.arquivos.addAll(arq);
  }

  @override
  void initState() {
    tamanhosFolha = TipoFolha.getTamanhoFolhas();
    controller.icon = (controller.arquivos.length == 1)
        ? Icon(Icons.done)
        : Icon(Icons.navigate_next);
    super.initState();
  }

  @override
  void dispose() {
    controller.arquivos.clear();
    controller.currentPageValue = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.pageController.addListener(() {
      controller.currentPageValue = controller.pageController.page;
      controller.icon = (controller.currentPageValue.toInt() ==
              controller.arquivos.length - 1)
          ? Icon(Icons.done)
          : Icon(Icons.navigate_next);
    });
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            "Arquivos",
          ),
        ),
        floatingActionButton: new Visibility(
            visible: _visibility,
            child: FloatingActionButton(
              onPressed: () {
                if ((controller.currentPageValue.toInt() ==
                    controller.arquivos.length - 1)) {
                  Navigator.pop(context, controller.arquivos);
                } else {
                  //setState(() {
                  controller.pageController.nextPage(
                      duration: Duration(milliseconds: 600),
                      curve: Curves.ease);

                  ///});
                }
              },
              tooltip: 'Confirmar',
              child: Observer(builder: (_) => controller.icon),
            )),
        body: _getFragent());
  }

  Widget _getFragent() {
    return FutureBuilder(
      future: controller.obterNumeroPaginas(),
      builder: (_, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snap.hasError || (snap.hasData && snap.data == false)) {
          return Center(
            child:
                FalhaWidget('Ops, houve uma falha ao carregar os documentos'),
          );
        }
        return new PageView.builder(
          controller: controller.pageController,
          itemCount: controller.arquivos.length,
          itemBuilder: (context, position) {
            return Observer(
                builder: (_) => _buildStoryPage(
                    controller.arquivos[position],
                    position == controller.currentPageValue.floor(),
                    position == 0
                        ? Colors.blue
                        : position == 1 ? Colors.cyan : Colors.greenAccent,
                    position));
          },
        );
      },
    );
  }

  _buildStoryPage(ArquivoImpressao arquivo, bool active, color, int index) {
    // Animated Properties
    final double blur = active ? 30 : 30;
    final double offset = active ? 20 : 10;
    final double top = active ? 20 : 60;

    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 10, right: 5, left: 5),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
        BoxShadow(
            color: Colors.black26,
            blurRadius: blur,
            offset: Offset(offset, offset))
      ]),
      child: _getCard(arquivo, index),
    );
  }

  Widget _getCard(ArquivoImpressao arquivo, int index) {
    return SingleChildScrollView(
      child: (Container(
          height: 500,
          padding: EdgeInsets.all(15.0),
          child: new Card(
              child: new Padding(
            padding: EdgeInsets.all(15.0),
            child: Container(
              height: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      '${arquivo.nome} - ${arquivo.num_paginas} pg',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  new Image.asset(
                    'imagens/pdf_icon.png',
                    width: 150,
                    height: 150,
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TipoFolhaWidget(TipoFolhaController(arquivo.tipoFolha)),
                        _textTitle('Número de cópias'),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new SizedBox(
                              height: 50,
                              child: Observer(
                                builder: (_) => new NumberPicker.integer(
                                    highlightSelectedValue: true,
                                    itemExtent: 35,
                                    zeroPad: false,
                                    scrollDirection: Axis.horizontal,
                                    initialValue: arquivo.quantidade ?? 1,
                                    minValue: 1,
                                    maxValue: 99,
                                    onChanged: (quantidade) {
                                      arquivo.quantidade = quantidade;
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              width: 150,
                              child: Observer(
                                builder: (_) => CheckboxListTile(
                                  title: Text("Colorido"),
                                  value: arquivo.colorido,
                                  onChanged: (newValue) {
                                    //setState(() {
                                    arquivo.colorido = newValue;
                                    //});
                                  },
                                  controlAffinity: ListTileControlAffinity
                                      .leading, //  <-- leading Checkbox
                                ),
                              ),
                            ),
                          ],
                        ),
                        _numeroPag(arquivo)
                      ],
                    ),
                  ), //getButtonUI(index, arquivo.tipoFolha, true)
                ],
              ),
            ),
          )))),
    );
  }

  Widget _numeroPag(ArquivoImpressao arquivo) {
    if (arquivo.num_paginas == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Infome o número de paginas do documento'),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SelecionarQuantidadeWidget(
                arquivo.num_paginas.toDouble(), controller.ctlQuantidade,
                alteravel: arquivo.num_paginas == 0, inteiro: true),
          ),
        ],
      );
    } else {
      return Container(width: 0, height: 0);
    }
  }

  Widget _textTitle(String text) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 15.0, left: 10, right: 10, bottom: 10),
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            //letterSpacing: 0.27,
          ),
        ));
  }
}
