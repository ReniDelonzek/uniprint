import 'package:cloud_firestore/cloud_firestore.dart';

class Disciplina {
  String nome;
  String id;

  static Disciplina fromDoc(DocumentSnapshot doc) {
    Disciplina disciplina = Disciplina();
    disciplina.nome = doc.data['nome'];
    disciplina.id = doc.documentID;
    return disciplina;
  }
}
