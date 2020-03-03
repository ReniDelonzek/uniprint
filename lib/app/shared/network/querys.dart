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
subscription getImpressoes(\$usuario_id: Int!) { 
  impressao(where: {usuario_id: {_eq: \$usuario_id}}, order_by: {id: desc}) {
    id
    comentario
    status
    usuario {
      id
    }
    arquivo_impressaos {
      colorido
      id
      nome
      quantidade
      num_paginas
      tipofolha {
        id
        nome
      }
      url
    }
    movimentacao_impressaos(order_by: {movimentacao: {tipo: asc}}) {
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
    descricao
    tipo
    titulo
    professor {
        usuario {
          pessoa {
            nome
          }
          url_foto
        }
    }
    arquivo_materials { 
      nome
      url
      num_paginas
    }
  }
}
""";
String getDetalhesUsuUsuario = """
 detalhesUso(\$usuario_id: Int!) {
  atendimento_aggregate(where: {usuario_id: {_eq: \$usuario_id}}) {
    aggregate {
      count(columns: id)
    }
  }
  impressao_aggregate(where: {usuario_id: {_eq: \$usuario_id}}) {
    aggregate {
      count(columns: id)
    }
  }
}
""";
