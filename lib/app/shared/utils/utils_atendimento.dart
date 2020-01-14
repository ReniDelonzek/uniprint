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
}
