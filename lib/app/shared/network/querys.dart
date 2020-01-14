String getAtendimentos = """subscription getAtendimentos { 
  atendimento {
    id
    data_solicitacao
    status
    ponto_atendimento_id 
    usuario_id
    usuario {
      email
      pessoa {
        nome
        id
      }
    }
    movimentacao_atendimentos {
      movimentacao {
        data
        tipo
      }
    }
  }
}""";
