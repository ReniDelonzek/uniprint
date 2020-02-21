import 'package:flutter/material.dart';
import 'package:uniprint/app/modules/impressao/cadastro_impressao/cadastro_impressao_module.dart';
import 'package:uniprint/app/modules/materiais/lista_materiais/lista_materiais_module.dart';
import 'package:uniprint/app/shared/models/graph/arquivo_impressao.dart';
import 'package:uniprint/app/shared/models/graph/materiais/arquivo_material.dart';
import 'package:uniprint/app/shared/models/graph/materiais/material.dart';
import 'package:uniprint/app/shared/models/graph/tipo_folha.dart';
import 'package:uniprint/app/shared/network/graph_ql_data.dart';
import 'package:uniprint/app/shared/network/querys.dart';
import 'package:uniprint/app/shared/temas/Tema.dart';
import 'package:uniprint/app/shared/widgets/falha/falha_widget.dart';

import 'lista_materiais_controller.dart';

class ListaMateriaisPage extends StatefulWidget {
  final String title;
  const ListaMateriaisPage({Key key, this.title = "ListaMateriais"})
      : super(key: key);

  @override
  _ListaMateriaisPageState createState() => _ListaMateriaisPageState();
}

class _ListaMateriaisPageState extends State<ListaMateriaisPage> {
  final controller = ListaMateriaisModule.to.bloc<ListaMateriaisController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Materiais publicados'),
      ),
      body: Builder(
          builder: (_) => Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 15),
              child: FutureBuilder(
                  future: GraphQlObject.hasuraConnect.query(getListaMateriais),
                  builder: (_, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return Center(child: RefreshProgressIndicator());
                    }
                    if (snap.hasError) {
                      return FalhaWidget(
                          "Houve uma falha ao tentar recuperar a lista de materias");
                    }
                    if (!snap.hasData ||
                        snap.data['data']['material'].isEmpty) {
                      return Center(child: Text("Não há nada por aqui..."));
                    }
                    controller.materiais.clear();
                    for (Map map in snap.data['data']['material']) {
                      controller.materiais.add(MaterialProf.fromMap(map));
                    }
                    return ListView.builder(
                      itemCount: controller.materiais.length,
                      itemBuilder: (_, pos) {
                        return _itemMaterial(pos);
                      },
                    );
                  }))),
    );
  }

  Widget _itemMaterial(int pos) {
    MaterialProf material = controller.materiais[pos];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        onTap: () {
          List<ArquivoImpressao> arquivos = List();
          if (material.arquivo_materials != null &&
              material.arquivo_materials.isNotEmpty) {
            for (ArquivoMaterial arquivoMaterial
                in material.arquivo_materials) {
              ArquivoImpressao arquivo = ArquivoImpressao();
              arquivo.nome = arquivoMaterial.nome;
              arquivo.url = arquivoMaterial.url;
              arquivo.colorido = material.colorido ?? false;
              arquivo.quantidade = 1;
              arquivo.tipoFolha = TipoFolha.getTamanhoFolhas().first;
              arquivo.tipo_folha_id = arquivo.tipoFolha.id;
              arquivos.add(arquivo);
            }
          }
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CadastroImpressaoModule(arquivos: arquivos)));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                material.titulo ?? 'Sem título definido',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(material.professor_turma?.turma?.disciplina?.nome ?? ''),
              Text(
                material.professor_turma?.professor?.usuario?.pessoa?.nome ??
                    '',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
