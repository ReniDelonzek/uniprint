import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:uniprint/app/modules/impressao/cadastro_impressao/cadastro_arquivos_impressao/cadastro_arquivos_impressao_controller.dart';
import 'package:uniprint/app/shared/models/graph/arquivo_impressao.dart';
import 'package:uniprint/app/shared/models/graph/tipo_folha.dart';

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
  Icon icon = Icon(Icons.navigate_next);
  bool _visibility = true;
  List<TipoFolha> tamanhosFolha = List();

  _CadastroArquivosImpressaoPageState(List<ArquivoImpressao> arq) {
    controller.arquivos.addAll(arq);
  }

  @override
  void initState() {
    tamanhosFolha = TipoFolha.getTamanhoFolhas();
    icon = (controller.arquivos.length == 1)
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
      setState(() {
        controller.currentPageValue = controller.pageController.page;
        icon = (controller.currentPageValue.toInt() ==
                controller.arquivos.length - 1)
            ? Icon(Icons.done)
            : Icon(Icons.navigate_next);
      });
    });
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            "Arquivos",
            style: new TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
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
              child: icon,
            )),
        backgroundColor: Colors.white,
        body: _getFragent());
  }

  Widget _getFragent() {
    return new PageView.builder(
      controller: controller.pageController,
      itemCount: controller.arquivos.length,
      itemBuilder: (context, position) {
        return _buildStoryPage(
            controller.arquivos[position],
            position == controller.currentPageValue.floor(),
            position == 0
                ? Colors.blue
                : position == 1 ? Colors.cyan : Colors.greenAccent,
            position);
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
      //color: Colors.cyan,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
          //    color: Colors.cyan,
          boxShadow: [
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
                      arquivo.nome,
                      style: new TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
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
                        _textTitle('Tipo de folha'),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            getButtonUI(index, tamanhosFolha[0],
                                arquivo.tipo_folha_id == tamanhosFolha[0].id),
                            getButtonUI(index, tamanhosFolha[1],
                                arquivo.tipo_folha_id == tamanhosFolha[1].id)
                          ],
                        ),
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
                      ],
                    ),
                  ), //getButtonUI(index, arquivo.tipoFolha, true)
                ],
              ),
            ),
          )))),
    );
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

  Widget getButtonUI(int position, TipoFolha tipoFolha, bool isSelected) {
    return Container(
        width: 80,
        height: 42,
        decoration: new BoxDecoration(
            color: (controller.arquivos[position].tipo_folha_id == tipoFolha.id)
                ? Colors.blue
                : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            border: new Border.all(color: Colors.blue)),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.white24,
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
              onTap: () {
                setState(() {
                  controller.arquivos[position].tipo_folha_id = tipoFolha.id;
                });
              },
              child: Padding(
                padding:
                    EdgeInsets.only(top: 12, bottom: 12, left: 18, right: 18),
                child: Center(
                  child: Text(
                    tipoFolha.nome,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        letterSpacing: 0.27,
                        color: isSelected ? Colors.white : Colors.blue),
                  ),
                ),
              ),
            )));
  }
}
