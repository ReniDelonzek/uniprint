import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:uniprint/app/shared/utils/constans.dart';

class UtilsAtendimento {
  static String tipoAtendimento(int tipo) {
    if (tipo == Constants.STATUS_ATENDIMENTO_ATENDIDO) {
      return 'Atendido';
    } else if (tipo == Constants.STATUS_ATENDIMENTO_CANCELADO_ATENDENTE) {
      return 'Cancelado pelo atendente';
    } else if (tipo == Constants.STATUS_ATENDIMENTO_CANCELADO_USUARIO) {
      return 'Você cancelou o atendimento';
    } else if (tipo == Constants.STATUS_ATENDIMENTO_SOLICITADO) {
      return 'Solicitado';
    } else if (tipo == Constants.STATUS_ATENDIMENTO_EM_ATENDIMENTO) {
      return 'Em atendimento';
    } else
      return '';
  }

   String getStatusAtendimento(int status, DateTime dataAtendimento) {
    switch (status) {
      case Constants.STATUS_ATENDIMENTO_SOLICITADO:
        return "Atendimento solicitado";
      case Constants.STATUS_ATENDIMENTO_EM_ATENDIMENTO:
        return "Atendimento em andamento";
      case Constants.STATUS_ATENDIMENTO_ATENDIDO:
        return "Você foi atendido em ${new DateFormat("dd/MM HH:mm").format(dataAtendimento ?? DateTime.now())}";
      case Constants.STATUS_ATENDIMENTO_CANCELADO_USUARIO:
        return "Atendimento cancelado pelo usuario";
      case Constants.STATUS_ATENDIMENTO_CANCELADO_ATENDENTE:
        return "Atendimento cancelado pelo atendente";

      default:
        return '';
    }
  }


  Widget getSatisfacao(int satisfacao) {
    switch (satisfacao) {
      case 0: //ruim
        return new Icon(Icons.sentiment_neutral, size: 15);
      case 1:
        return new Icon(Icons.sentiment_satisfied, size: 15);
      case 2:
        return new Icon(Icons.sentiment_very_satisfied, size: 15);
      default:
        return new Icon(Icons.sentiment_satisfied, size: 15);
    }
  }

}
