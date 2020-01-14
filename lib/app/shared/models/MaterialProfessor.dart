import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniprint/app/shared/models/ArquivoMaterial.dart';
 
class MaterialProfessor {
  String titulo;
  String nomeProfessor;
  String idProfessor;
  DateTime dataPostagem;
  DateTime dataDisp;
  String codDisciplina;

  int tipo = 0; //0 = arquivos, 1 = material no local
  //opcional
  String local;
  String descricao;
  double valorTotal;
  int quantidadeFolhas;
  String tipoFolha;
  bool colorido;

  List<ArquivoMaterial> arquivos = List();

  Map<String, dynamic> toJson() => {
        'titulo': titulo,
        'nomeProfessor': nomeProfessor,
        'idProfessor': idProfessor,
        'dataPostagem': dataPostagem,
        'dataDisp': dataDisp,
        'tipo': tipo,
        'local': local,
        'descricao': descricao,
        'valorTotal': valorTotal,
        'quantidadeFolhas': quantidadeFolhas,
        'tipoFolha': tipoFolha,
        'colorido': colorido,
        'codDisciplina': codDisciplina
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
