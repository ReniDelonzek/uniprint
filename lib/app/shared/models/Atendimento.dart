import 'package:cloud_firestore/cloud_firestore.dart';

class Atendimento {
  String id;
  String codSolicitante;
  DateTime dataSolicitacao;
  String codPonto;
  int status;
  int satisfacao;
  DateTime dataAtendimento;

  Map<String, dynamic> toJson() => {
        'codSolicitante': codSolicitante,
        'dataSolicitacao': dataSolicitacao,
        'codPonto': codPonto,
        'status': status,
        'satisfacao': satisfacao,
      };

  static Atendimento fromJson(Map<String, dynamic> map) {
    Atendimento atendimento = Atendimento();
    atendimento.codSolicitante = map['codSolicitante'];
    atendimento.dataSolicitacao =
        (map['dataSolicitacao'] ?? Timestamp.fromMillisecondsSinceEpoch(0))
            .toDate();
    atendimento.codPonto = map['codPonto'];
    atendimento.status = map['status'];
    atendimento.satisfacao = map['satisfacao'];
    atendimento.dataAtendimento = ((map['dataAtendimento'] as Timestamp) ??
            Timestamp.fromMillisecondsSinceEpoch(0))
        .toDate();
    return atendimento;
  }
}
