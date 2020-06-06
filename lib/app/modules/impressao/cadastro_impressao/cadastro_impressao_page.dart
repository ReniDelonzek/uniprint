import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mobx/mobx.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sprintf/sprintf.dart';
import 'package:uniprint/app/modules/impressao/cadastro_impressao/cadastro_arquivos_impressao/cadastro_arquivos_impressao_module.dart';
import 'package:uniprint/app/shared/db/hive/tipo_folha.dart';
import 'package:uniprint/app/shared/models/graph/arquivo_impressao.dart';
import 'package:uniprint/app/shared/models/graph/ponto_atendimento.dart';
import 'package:uniprint/app/shared/utils/utils_cadastro.dart';
import 'package:uniprint/app/shared/utils/utils_impressao.dart';
import 'package:uniprint/app/shared/utils/utils_sentry.dart';
import 'package:uniprint/app/shared/widgets/button.dart';
import 'package:uniprint/app/shared/widgets/pontos_atendimento/pontos_atendimento_widget.dart';

import 'cadastro_impressao_controller.dart';
import 'cadastro_impressao_module.dart';

class CadastroImpressaoPage extends StatefulWidget {
  final String title;
  const CadastroImpressaoPage({Key key, this.title = "Cadastro Impressao"})
      : super(key: key);

  @override
  _CadastroImpressaoPageState createState() => _CadastroImpressaoPageState();
}

class _CadastroImpressaoPageState extends State<CadastroImpressaoPage> {
  final _controller =
      CadastroImpressaoModule.to.bloc<CadastroImpressaoController>();

  var inicializados =
      false; //arquivos enviados de outra tela ja tiveram suas proprietades configuradas

  _CadastroImpressaoPageState({PontoAtendimento local}) {
    if (local != null) {
      _controller.local = local;
    }
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Solicitar impressão"),
        ),
        body:
            Builder(builder: (context) => _getPageCadastroImpressao(context)));
  }

  verificarArquivos(context) async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (_controller.arquivos?.isNotEmpty == true && !inicializados) {
        inicializados = true;
        var arquivosA = await Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) =>
                new CadastroArquivosImpressaoModule(
                  _controller.arquivos,
                )));
        if (arquivosA != null) {
          if (this._controller.arquivos == null) {
            _controller.arquivos = ObservableList<ArquivoImpressao>();
          }
          _controller.arquivos = ObservableList.of(arquivosA);
        }
      }
    });
  }

  Widget _getPageCadastroImpressao(BuildContext context) {
    verificarArquivos(context);
    return new Container(
      child: new Stack(
        children: <Widget>[
          Positioned(
              child: Align(
                  alignment: FractionalOffset.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: Column(
                      children: [getLocais(), _getArquivos()],
                    ),
                  ))),
          Positioned(
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: _getBottom(context)),
          )
        ],
        //mainAxisSize: MainAxisSize.max,
      ),
    );
  }

  void selecionarArquivo() async {
    ProgressDialog progressDialog = ProgressDialog(context)
      ..style(message: 'Carregando Arquivos');
    progressDialog.show();
    Map<String, String> filePaths = await FilePicker.getMultiFilePath(
        type: FileType.CUSTOM, fileExtension: 'pdf');
    progressDialog.dismiss();
    if (filePaths != null && filePaths.isNotEmpty) {
      List<ArquivoImpressao> arquivos = List();
      for (var item in filePaths.entries) {
        var arquivo = ArquivoImpressao();
        arquivo.nome = item.key;
        arquivo.path = item.value;
        arquivo.quantidade = 1;
        arquivo.colorido = false;
        arquivo.tipo_folha_id = 1;
        arquivo.tipoFolha = TipoFolha.getTamanhoFolhas().first;
        arquivos.add(arquivo);
      }
      inicializados = true;
      var arquivosA = await Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) =>
              new CadastroArquivosImpressaoModule(
                arquivos,
              )));
      if (arquivosA != null) {
        setState(() {
          if (this._controller.arquivos == null) {
            this._controller.arquivos = ObservableList<ArquivoImpressao>();
          }
          this._controller.arquivos.addAll(arquivosA);
        });
      }
    }
  }

  Widget _textTitle(String text) {
    return Padding(
        padding: const EdgeInsets.only(top: 0.0, left: 10, right: 16),
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 0.27,
          ),
        ));
  }

  Widget _getArquivos() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _textTitle('Arquivos'),
            (_controller.arquivos != null && _controller.arquivos.isNotEmpty)
                ? Expanded(
                    child: Observer(
                    builder: (_) => StaggeredGridView.extentBuilder(
                        maxCrossAxisExtent: 200,
                        staggeredTileBuilder: (int index) =>
                            new StaggeredTile.fit(1),
                        //scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(top: 16),
                        itemCount: _controller.arquivos?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return new Container(
                              //padding: EdgeInsets.all(5),
                              child: _getItemList(index));
                        }),
                  ))
                : Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(
                            'imagens/adc_arquivos.png',
                            width: 120,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child:
                                Text("Clique em '+' para adicionar arquivos"),
                          )
                        ],
                      ),
                    ),
                  ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(right: 16, bottom: 12),
                    child: Observer(
                      builder: (_) => FutureBuilder(
                          future: UtilsImpressao.getValorImpressaoArquivos(
                              _controller.arquivos),
                          builder: (_, snap) {
                            if (snap.connectionState ==
                                ConnectionState.waiting) {
                              return _getTextoValorTotal(
                                  'Calculando valor da impressão...');
                            } else if (snap.hasError) {
                              return _getTextoValorTotal(
                                  'Ops, houve uma falha ao calcular o preço total 😬');
                            } else {
                              if (snap.data?.toDouble() == 0.0) {
                                return Text('');
                              }
                              String valor =
                                  sprintf('%.2f', [snap.data.toDouble()])
                                      .replaceAll('.', ',');
                              return _getTextoValorTotal(
                                  'Valor total: R\$$valor');
                            }
                          }),
                    )),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: new Align(
                      alignment: Alignment.bottomRight,
                      child: new FloatingActionButton(
                        onPressed: () {
                          selecionarArquivo();
                        },
                        child: new Icon(Icons.add),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTextoValorTotal(String msg) {
    return Text(
      msg,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    );
  }

  Widget _getItemList(int pos) {
    ArquivoImpressao arquivo = _controller.arquivos[pos];
    return new SizedBox(
      width: 100,
      height: 170,
      child: Card(
        child: InkWell(
          onTap: () {
            _removerItem(pos);
          },
          child: new Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                new Image.asset(
                  'imagens/pdf_icon.png',
                  width: 80,
                  height: 100,
                ),
                new Text(
                  '${arquivo.nome} - ${arquivo.num_paginas}pg',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
                new Text(
                  '${arquivo.quantidade} cópia${arquivo.quantidade > 1 ? 's' : ''} - ${arquivo.tipoFolha?.nome}',
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getLocais() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        PontosAtendimentoWidget(
          'Selecione o Local',
          (local) {
            _controller.local = local;
          },
          _controller.ctlPontosAtendimento,
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  void _removerItem(int pos) {
    showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
              onClosing: () {},
              builder: (_) => Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('Remover'),
                    leading: Icon(Icons.close),
                    onTap: () {
                      _controller.arquivos.removeAt(pos);
                      Navigator.pop(context);
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  )
                ],
              ),
            ));
  }

  Widget _getBottom(BuildContext context) {
    return Card(
      elevation: 0,
      child: SizedBox(
        height: 55,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Row(children: <Widget>[
            Flexible(
                child: Container(
              child: TextFormField(
                decoration: InputDecoration(hintText: 'Envie um comentário...'),
                textCapitalization: TextCapitalization.sentences,
                controller: _controller.controllerObs,
              ),
            )),
            Button('Solicitar', () async {
              String msg = _controller.verificarDados();
              if (msg == null) {
                FocusScope.of(context).requestFocus(FocusNode());
                ProgressDialog progressDialog = ProgressDialog(context)
                  ..style(message: 'Verificando seu histórico...')
                  ..show();
                String msg2 = await _controller.validarPermissao();
                if (msg2 == null) {
                  try {
                    progressDialog.style(
                        message: 'Enviando dados para o servidor...');
                    var res = await _controller.cadastrarDados();
                    progressDialog.dismiss();
                    if (res != null) {
                      showSnack(context, 'Impressão cadastrada com sucesso!',
                          dismiss: true);
                    } else {
                      showSnack(context,
                          'Ops, houve uma falha ao cadastrar a impressão');
                    }
                  } catch (error, stackTrace) {
                    progressDialog.dismiss();
                    showSnack(context,
                        'Ops, houve uma falha ao cadastrar a impressão');
                    UtilsSentry.reportError(error, stackTrace);
                  }
                } else {
                  progressDialog.dismiss();
                  _exibirAlertaPermissaoInsuficiente(msg2);
                }
              } else {
                showSnack(context, msg);
              }
            })
          ]),
        ),
      ),
    );
  }

  _exibirAlertaPermissaoInsuficiente(String msg) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Oops'),
              content: Text(msg),
              actions: <Widget>[
                FlatButton(
                    child: Text('Entendi'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ));
  }
}
