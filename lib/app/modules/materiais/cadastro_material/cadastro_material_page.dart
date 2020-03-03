import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uniprint/app/app_module.dart';
import 'package:uniprint/app/shared/auth/hasura_auth_service.dart';
import 'package:uniprint/app/shared/models/graph/materiais/arquivo_material.dart';
import 'package:uniprint/app/shared/models/graph/ponto_atendimento.dart';
import 'package:uniprint/app/shared/network/graph_ql_data.dart';
import 'package:uniprint/app/shared/network/mutations.dart';
import 'package:uniprint/app/shared/utils/utils_cadastro.dart';
import 'package:uniprint/app/shared/utils/utils_firebase_file.dart';
import 'package:uniprint/app/shared/utils/utils_platform.dart';
import 'package:uniprint/app/shared/widgets/widgets.dart';

import 'cadastro_material_controller.dart';
import 'cadastro_material_module.dart';

class CadastroMaterialPage extends StatefulWidget {
  final String title;
  const CadastroMaterialPage({Key key, this.title = "Cadastrar Material"})
      : super(key: key);

  @override
  _CadastroMaterialPageState createState() => _CadastroMaterialPageState();
}

class _CadastroMaterialPageState extends State<CadastroMaterialPage> {
  final _controller =
      CadastroMaterialModule.to.bloc<CadastroMaterialController>();

  PontoAtendimento local;

  List<ArquivoMaterial> arquivos = List();
  int quantidade = 1;
  bool colorido = false;
  String tipoFolha = "A4";
  BuildContext buildContext;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            "Cadastrar Material",
            style: new TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ButtonTheme(
            height: 42,
            minWidth: 140,
            child: RaisedButton(
              onPressed: () async {
                if (verificarDados(buildContext)) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  ProgressDialog progress = ProgressDialog(context);
                  progress.style(message: 'Cadastrando material');
                  progress.show();
                  try {
                    for (ArquivoMaterial arquivo in arquivos) {
                      if (arquivo.url == null) {
                        File file = File(arquivo.path);
                        arquivo.url = await UtilsFirebaseFile.putFile(file,
                            'Materiais/professor_id/${file.path.split('/').last}');
                      }
                    }

                    var res = await GraphQlObject.hasuraConnect
                        .mutation(cadastroMaterial, variables: {
                      'professor_id': AppModule.to
                              .getDependency<HasuraAuthService>()
                              .usuario
                              ?.codProfessor ??
                          6,
                      'tipo_folha_id': 1,
                      'colorido': colorido,
                      'data_publicacao': DateFormat('yyyy-MM-ddTHH:mm:ss')
                          .format(DateTime.now()),
                      'tipo': _controller.enviarArquivos ? 0 : 1,
                      'titulo': _controller.controllerTitulo.text,
                      'descricao': _controller.controllerDescricao.text,
                      'arquivos':
                          arquivos.map((arquivo) => arquivo.toMap()).toList()
                    });
                    if (progress != null && progress.isShowing()) {
                      progress.dismiss();
                    }
                    if (res != null) {
                      showSnack(
                          buildContext, 'Material cadastrado com sucesso!',
                          dismiss: true);
                    } else {
                      showSnack(buildContext,
                          'Ops, houve uma falha ao cadastrar o material');
                    }
                  } catch (e) {
                    print(e);
                    if (progress != null && progress.isShowing()) {
                      progress.dismiss();
                    }
                    showSnack(buildContext,
                        'Ops, houve uma falha ao cadastrar o material');
                  }
                }
              },
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22.0),
              ),
              child: new Text(
                "SALVAR",
                style: new TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )),
        backgroundColor: Colors.white,
        body: Builder(builder: (context) => _getBody(context)));
  }

  Widget _getBody(BuildContext context) {
    buildContext = context;
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black45),
                  labelText: 'Defina um título',
                ),
                controller: _controller.controllerTitulo,
                textCapitalization: TextCapitalization.sentences,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black45),
                  labelText: 'Descrição',
                ),
                controller: _controller.controllerDescricao,
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
        ),
        Observer(
          builder: (_) => CheckboxListTile(
            title: Text("Anexar arquivos"),
            value: _controller.enviarArquivos,
            onChanged: (newValue) {
              //setState(() {
              _controller.enviarArquivos = newValue;
              //});
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
        ),
        Observer(builder: (_) => _listaOpcoes())
      ],
    );
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

  Widget _getItemList(ArquivoMaterial arquivo) {
    return new SizedBox(
      width: 100,
      height: 170,
      child: Card(
        child: InkWell(
          onLongPress: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text('Deseja remover o arquivo?'),
                      content: Text('Clique para confirmar'),
                      actions: <Widget>[
                        new FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancelar')),
                        new FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                arquivos.remove(arquivo);
                              });
                            },
                            child: Text('Sim')),
                      ]);
                });
          },
          onTap: () {},
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
                  arquivo.nome,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selecionarArquivo() async {
    Map<String, String> filePaths = await FilePicker.getMultiFilePath(
        type: FileType.CUSTOM, fileExtension: 'pdf');
    if (filePaths != null) {
      ProgressDialog progressDialog = ProgressDialog(context)
        ..style(message: 'Coletando dados do arquivo...');
      //todo ver pq aqui estava aparecendo so depois do arquivo ja adicionado a lista

      List<ArquivoMaterial> arquivos = List();
      for (var item in filePaths.entries) {
        var arquivo = ArquivoMaterial();
        arquivo.nome = item.key;
        arquivo.path = item.value;
        PdfDocument document = await PdfDocument.openFile(item.value);
        arquivo.num_paginas = document.pageCount;
        await document.dispose();
        arquivos.add(arquivo);
      }

      setState(() {
        this.arquivos.addAll(arquivos);
      });
    }
  }

  bool verificarDados(BuildContext context) {
    if (_controller.controllerTitulo.text.isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Por favor, insira um título para o material'),
        duration: Duration(seconds: 3),
      ));
      return false;
    } else if (!_controller.enviarArquivos && local == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
            'Você precisa selecionar o local onde o material vai estar disponível'),
        duration: Duration(seconds: 3),
      ));
      return false;
    } else if (_controller.enviarArquivos && arquivos.isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Você precisa anexar pelo menos um arquivo'),
        duration: Duration(seconds: 3),
      ));
      return false;
    } else
      return true;
  }

  Widget _listaOpcoes() {
    if (_controller.enviarArquivos) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _textTitle('Selecione os arquivos'),
              Expanded(
                  child: StaggeredGridView.extentBuilder(
                      maxCrossAxisExtent: 200,
                      staggeredTileBuilder: (int index) =>
                          new StaggeredTile.fit(1),
                      //scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(top: 16),
                      itemCount: arquivos.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return new Container(
                            child: _getItemList(arquivos[index]));
                      })),
              Padding(
                padding: EdgeInsets.all(5),
                child: Center(
                  child: new Align(
                      alignment: Alignment.bottomRight,
                      child: new FloatingActionButton(
                        onPressed: () {
                          selecionarArquivo();
                        },
                        child: new Icon(Icons.add),
                      )),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Expanded(child: _layoutDetalhesMaterial());
    }
  }

  _layoutDetalhesMaterial() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new LocaisAtendimento(
          'Local do material',
          (local) {
            setState(() {
              this.local = local;
            });
          },
          local: local,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
          child: Text(
            'Informe o tipo de folha que deve ser impresso',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ChipButtonState('A3', tipoFolha == 'A3', () {
                setState(() {
                  tipoFolha = 'A3';
                });
              }),
              ChipButtonState('A4', tipoFolha == 'A4', () {
                setState(() {
                  tipoFolha = 'A4';
                });
              })
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
          child: Text(
            'Número de folhas',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new SizedBox(
              height: 50,
              child: new NumberPicker.integer(
                  highlightSelectedValue: true,
                  itemExtent: 35,
                  zeroPad: false,
                  scrollDirection: Axis.horizontal,
                  initialValue: quantidade,
                  minValue: 1,
                  maxValue: 99,
                  onChanged: (quantidade) {
                    setState(() {
                      this.quantidade = quantidade;
                    });
                  }),
            ),
            SizedBox(
              height: 50,
              width: 150,
              child: CheckboxListTile(
                title: Text("Colorido"),
                value: colorido,
                onChanged: (newValue) {
                  setState(() {
                    colorido = newValue;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<String> uploadFile(String patchServer, String patchLocal) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child((UtilsPlatform.isDebug() ? 'DEBUG/' : '') + patchServer);
    StorageUploadTask uploadTask = storageReference.putFile(File(patchLocal));
    await uploadTask.onComplete;
    return await storageReference.getDownloadURL();
  }
}
