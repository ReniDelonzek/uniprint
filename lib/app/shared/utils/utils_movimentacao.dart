import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'constans.dart';

class UtilsMovimentacao {
  static IconData getIconeAtendimento(int tipoMovimento) {
    switch (tipoMovimento) {
      case Constants.MOV_ATENDIMENTO_SOLICITADO:
        return Icons.star;
      case Constants.MOV_ATENDIMENTO_EM_ATENDIMENTO:
        return Icons.settings;
      case Constants.MOV_ATENDIMENTO_ATENDIDO:
        return Icons.done;
      case Constants.MOV_ATENDIMENTO_CANCELADO_USUARIO:
        return Icons.close;
      case Constants.MOV_ATENDIMENTO_CANCELADO_ATENDENTE:
        return Icons.close;
      case Constants.MOV_IMPRESSAO_SOLICITADO:
        return Icons.star;
      case Constants.MOV_IMPRESSAO_AUTORIZADO:
        return Icons.done;
      case Constants.MOV_IMPRESSAO_AGUARDANDO_RETIRADA:
        return Icons.local_printshop;
      case Constants.MOV_IMPRESSAO_RETIRADA:
        return Icons.done_all;
      case Constants.MOV_IMPRESSAO_CANCELADO:
        return Icons.close;
      case Constants.MOV_IMPRESSAO_NEGADA:
        return Icons.error_outline;
      default:
        return Icons.star;
    }
  }

  static Color getColorIcon(int tipoMovimento) {
    switch (tipoMovimento) {
      case Constants.MOV_ATENDIMENTO_SOLICITADO:
        return Colors.cyan;
      case Constants.MOV_ATENDIMENTO_EM_ATENDIMENTO:
        return Colors.blue;
      case Constants.MOV_ATENDIMENTO_ATENDIDO:
        return Colors.green;
      case Constants.MOV_ATENDIMENTO_CANCELADO_USUARIO:
        return Colors.red;
      case Constants.MOV_ATENDIMENTO_CANCELADO_ATENDENTE:
        return Colors.red;
      case Constants.MOV_IMPRESSAO_SOLICITADO:
        return Colors.cyan;
      case Constants.MOV_IMPRESSAO_AUTORIZADO:
        return Colors.blue;
      case Constants.MOV_IMPRESSAO_AGUARDANDO_RETIRADA:
        return Colors.yellow;
      case Constants.MOV_IMPRESSAO_RETIRADA:
        return Colors.green;
      case Constants.MOV_IMPRESSAO_CANCELADO:
        return Colors.red;
      case Constants.MOV_IMPRESSAO_NEGADA:
        return Colors.red;
      default:
        return Colors.cyan;
    }
  }
}
