import 'package:cloud_firestore/cloud_firestore.dart';
 
import 'ArquivoMaterial.dart';

class MaterialProfessor {
  String titulo;
  DateTime data_publicacao;
  int tipo = 0; //0 = arquivos, 1 = material no local
  int ponto_atendimento_id;
  String descricao;
  String tipo_folha_id;
  bool colorido;

  List<ArquivoMaterial> arquivos = List();

  Map<String, dynamic> toJson() => {
        'titulo': titulo,
        'data_publicacao': data_publicacao,
        'tipo': tipo,
        'descricao': descricao,
        'tipo_folha_id': tipo_folha_id,
        'colorido': colorido,
        'ponto_atendimento_id': ponto_atendimento_id,
      };

  static MaterialProfessor fromDoc(DocumentSnapshot doc) {
    Map map = Map<String, dynamic>();
    map['titulo'] = doc.data['titulo'];
    map['nomeProfessor'] = doc.data['nomeProfessor'];
    map['idProfessor'] = doc.data['idProfessor'];
    map['dataPostagem'] = doc.data['dataPostagem'];
    map['dataDisp'] = doc.data['dataDisp'];
    map['tipo'] = doc.data['tipo'];
    map['local'] = doc.data['local'];
    map['descricao'] = doc.data['descricao'];
    map['valorTotal'] = doc.data['valorTotal'];
    map['quantidadeFolhas'] = doc.data['quantidadeFolhas'];
    map['tipoFolha'] = doc.data['tipoFolha'];
    map['colorido'] = doc.data['colorido'];
    map['codDisciplina'] = doc.data['codDisciplina'];
  }
}
