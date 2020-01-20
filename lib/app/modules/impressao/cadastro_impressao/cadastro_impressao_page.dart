import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uniprint/app/modules/impressao/cadastro_impressao/cadastro_arquivos_impressao/cadastro_arquivos_impressao_module.dart';
import 'package:uniprint/app/shared/models/Impressao.dart';
import 'package:uniprint/app/shared/models/LocalAtendimento.dart';
import 'package:uniprint/app/shared/models/arquivo_impressao.dart';
import 'package:uniprint/app/shared/network/graph_ql_data.dart';
import 'package:uniprint/app/shared/network/mutations.dart';
import 'package:uniprint/app/shared/utils/utils_cadastro.dart';
import 'package:uniprint/app/shared/utils/utils_firebase_file.dart';
import 'package:uniprint/app/shared/utils/utils_impressao.dart';
import 'package:uniprint/app/shared/widgets/widgets.dart';

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
  final controller = CadastroImpressaoModule.to.bloc<CadastroImpressaoController>();
  final controllerObs = TextEditingController();
  LocalAtendimento local;

  ///ProgressDialog progressDialog;
  var inicializados =
      false; //arquivos enviados de outra tela ja tiveram suas proprietades configuradas

  _CadastroImpressaoPageState({this.local});

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
        backgroundColor: Colors.white,
        body:
            Builder(builder: (context) => _getPageCadastroImpressao(context)));
  }

  Listener maskj() {
    return Listener();
  }

  verificarArquivos(context) async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (controller.arquivos?.isNotEmpty == true && !inicializados) {
        inicializados = true;
        var arquivosA = await Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) =>
                new CadastroArquivosImpressaoModule(
                  controller.arquivos,
                )));
        if (arquivosA != null) {
          setState(() {
            if (this.controller.arquivos == null) {
               controller.arquivos = List<ArquivoImpressao>();
            }
            controller.arquivos = (arquivosA);
          });
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

  void solicitarImpressao() {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        UtilsImpressao.getValorImpressaoArquivos(controller.arquivos).then((total) {
          Impressao impressao = Impressao();
          impressao.valorTotal = total;
          impressao.status = 0;
          impressao.codPonto = local.id;
          impressao.codSolicitante = user.uid;
          impressao.dataSolicitacao = DateTime.now();
          impressao.comentario = controllerObs.text;
          impressao.descricao = UtilsImpressao.getResumo(controller.arquivos);
          var db = Firestore.instance
              .collection("Empresas")
              .document("Uniguacu")
              .collection("Pontos")
              .document(local.id)
              .collection("Impressoes");
          String id = db.document().documentID;

          db.document(id).setData(impressao.toJson()).whenComplete(() async {
            for (int i = 0; i < controller.arquivos.length; i++) {
              if (controller.arquivos[i].url == null || controller.arquivos[i].url.isEmpty) {
                await uploadFile(id, i.toString(), controller.arquivos[i]);
              }
            }

            Navigator.of(this.context).pop(); //fecha o dialogo
            Navigator.of(this.context).pop(); //fecha a tela
          }).catchError((error) {
            print(error);
            Navigator.of(this.context).pop(); //fecha o dialogo
            Scaffold.of(context).showSnackBar(new SnackBar(
              content:
                  new Text("Oops, houve uma falha ao solicitar uma impressão"),
            ));
            //Navigator.of(this.context).pop();
          });
        });
      }
    }).catchError((error) {});
  }

  void selecionarArquivo() async {
    Map<String, String> filePaths = await FilePicker.getMultiFilePath(
        //type: FileType.CUSTOM, fileExtension: 'pdf'
        );
    if (filePaths != null && filePaths.isNotEmpty) {
      List<ArquivoImpressao> arquivos = List();
      for (var item in filePaths.entries) {
        var arquivo = ArquivoImpressao();
        arquivo.nome = item.key;
        arquivo.patch = item.value;
        arquivo.quantidade = 1;
        arquivo.colorido = false;
        arquivo.tipo_folha_id = "A4";
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
          if (this.controller.arquivos == null) {
            this.controller.arquivos = List<ArquivoImpressao>();
          }
          this.controller.arquivos.addAll(arquivosA);
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
            Expanded(
                child: StaggeredGridView.extentBuilder(
                    maxCrossAxisExtent: 200,
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.fit(1),
                    //scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(top: 16),
                    itemCount: controller.arquivos?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
                          //padding: EdgeInsets.all(5),
                          child: _getItemList(controller.arquivos[index]));
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
  }

  Widget _getItemList(ArquivoImpressao arquivo) {
    return new SizedBox(
      width: 100,
      height: 170,
      child: Card(
        child: InkWell(
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
                  maxLines: 1,
                ),
                new Text(
                    '${arquivo.quantidade} cópias - ${arquivo.tipo_folha_id}')
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
        LocaisAtendimento(
          'Selecione o Local',
          (local) {
            setState(() {
              this.local = local;
            });
          },
          local: local,
        ),
        /**/
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget getButtonUI(LocalAtendimento localAtendimento) {
    bool isSelected = localAtendimento.id == local?.id;
    var txt = localAtendimento.nome;
    return Expanded(
        child: Container(
            decoration: new BoxDecoration(
                color: isSelected ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
                border: new Border.all(color: Colors.blue)),
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.white24,
                  borderRadius: BorderRadius.all(Radius.circular(24.0)),
                  onTap: () {
                    setState(() {
                      local = localAtendimento;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 12, bottom: 12, left: 18, right: 18),
                    child: Center(
                      child: Text(
                        txt,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            letterSpacing: 0.27,
                            color: isSelected ? Colors.white : Colors.blue),
                      ),
                    ),
                  ),
                ))));
  }

  // Future<void> _showDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(''),
  //         content: new Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[new CircularProgressIndicator()],
  //         ),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('Cancelar'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget newTitle(String string) {
    return new Padding(
        padding: EdgeInsets.all(5),
        child: new Text(string,
            style: new TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20)));
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
                controller: controllerObs,
              ),
            )),
            new Container(
                alignment: Alignment.bottomRight,
                child: new ButtonTheme(
                  height: 40,
                  minWidth: 120,
                  child: new RaisedButton(
                      onPressed: () async {
                        if (verificarDados(context)) {
                          ProgressDialog progressDialog =
                              ProgressDialog(context);
                          progressDialog.style(
                              message:
                                  'Enviando dados para o servidor, por favor aguarde...');
                          progressDialog.show();
                          DateTime data = DateTime.now();
                          for (int i = 0; i < controller.arquivos.length; i++) {
                            if (controller.arquivos[i].url == null ||
                                controller.arquivos[i].url.isEmpty) {
                              File file = File(controller.arquivos[i].patch);
                              controller.arquivos[i].url = await UtilsFirebaseFile.putFile(
                                  file,
                                  'Impressoes/${1}/${DateFormat('yyyyMMddHHmm').format(data)}/${file.path.split('/').last}');
                            }
                          }
                          try {
                            var res = await GraphQlObject.hasuraConnect
                                .mutation(cadastroImpressao, variables: {
                              'data': DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(data),
                              'usuario_id': 1,
                              'tipo': 2,
                              'comentario': controllerObs.text,
                              'arquivos': controller.arquivos
                                      ?.toList()
                                      ?.map((a) => a.toJson())
                                      ?.toList() ??
                                  ''
                            });
                            progressDialog.dismiss();
                            if (res != null) {
                              showSnack(context,
                                  'Atendimento cadastrado com sucesso!',
                                  dismiss: true);
                            }
                          } catch (e) {
                            progressDialog.dismiss();
                            showSnack(context,
                                'Ops, houve uma falha ao cadastrar o atendimento');
                            print(e);
                          }
                        }
                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.blue,
                      child: new Text(
                        "Solicitar",
                        style: TextStyle(color: Colors.white),
                      )),
                ))
          ]),
        ),
      ),
    );
  }

  bool verificarDados(BuildContext context) {
    if (local == null) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Você precisa selecinar o local da impressão"),
      ));
      return false;
    } else if (controller.arquivos?.isEmpty == true) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Você precisa selecinar pelo menos um arquivo"),
      ));
      return false;
    } else
      return true;
  }

  Future uploadFile(
      String impressaoID, String id, ArquivoImpressao arquivo) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Impressoes/$impressaoID/$id');
    StorageUploadTask uploadTask =
        storageReference.putFile(File(arquivo.patch));
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL) async {
      arquivo.url = fileURL;
      await Firestore.instance
          .collection("Empresas")
          .document("Uniguacu")
          .collection("Pontos")
          .document(local.id)
          .collection("Impressoes")
          .document(impressaoID)
          .collection('Documentos')
          .add(arquivo.toJson())
          .then((sucesso) {
        return true;
      }).catchError((error) {
        return false;
      });
    });
  }
}
