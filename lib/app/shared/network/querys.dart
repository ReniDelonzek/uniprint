String getAtendimentos = """subscription getAtendimentos(\$usuario_id: Int!) { 
  atendimento(where: {usuario_id: {_eq: \$usuario_id}}, order_by: {id: desc}) {
    id
    data_solicitacao
    status
    ponto_atendimento_id 
    usuario_id
    usuario {
      id
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

String getImpressoes = """
subscription MySubscription {
  impressao {
    comentario
    status
    arquivo_impressaos {
      colorido
      id
      nome
      quantidade
      tipofolha {
        nome
      }
      url
    }
    movimentacao_impressaos {
      movimentacao {
        tipo
        data
      }
    }
  }
}
""";

String posicaoAtendimento = """
subscription posicaoAtendimento(\$id: Int!) {
  atendimento_aggregate(where: {status: {_eq: 1}, _and: {id: {_gt: \$id}}}) {
    aggregate {
      count(columns: id)
    }
  }
}

""";

String getListaMateriais = """query materiais {
  material {
    colorido
    data_publicacao
    id
    ponto_atendimento {
      nome
    }
    tipo
    titulo
    professor_turma {
      professor {
        usuario {
          pessoa {
            nome
          }
          url_foto
        }
      }
    }
  }
}
""";