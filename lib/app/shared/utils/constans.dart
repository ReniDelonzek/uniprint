class Constants {
  static const int STATUS_ATENDIMENTO_SOLICITADO = 1;
  static const int STATUS_ATENDIMENTO_EM_ATENDIMENTO = 2;
  static const int STATUS_ATENDIMENTO_ATENDIDO = 3;
  static const int STATUS_ATENDIMENTO_CANCELADO_USUARIO = 4;
  static const int STATUS_ATENDIMENTO_CANCELADO_ATENDENTE = 5;

  static const int STATUS_IMPRESSAO_SOLICITADO = 1;
  static const int STATUS_IMPRESSAO_AUTORIZADO = 2;
  static const int STATUS_IMPRESSAO_AGUARDANDO_RETIRADA = 3;
  static const int STATUS_IMPRESSAO_RETIRADA = 4;
  static const int STATUS_IMPRESSAO_CANCELADO = 5;
  static const int STATUS_IMPRESSAO_NEGADA = 6;

  //tipos de notificacao
  static const int NOFITICACAO_CHAMADA_ATENDIMENTO = 1;
  static const int NOFITICACAO_IMPRESSAO_FINALIZADA = 2;
  static const int NOFITICACAO_ = 1;

  static const String TIPO_USUARIO = 'tipo_usuario';

  static const int USUARIO_NORMAL = 0;
  static const int USUARIO_ATENDENTE = 1;
  static const int USUARIO_PROFESSOR = 2;

  static const String MESSAGING_TOKEN = "messaging_token";
}
