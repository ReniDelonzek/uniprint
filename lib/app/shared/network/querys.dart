class Querys {
  static const String getAtendimentos =
      """subscription getAtendimentos(\$usuario_id: Int!) { 
  atendimento(where: {usuario_id: {_eq: \$usuario_id}}, order_by: {id: desc}) {
    id
    data_solicitacao
    status
    ponto_atendimento_id 
    usuario_id
    nota_atendimento
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

  static const String getImpressoes = """
subscription getImpressoes(\$usuario_id: Int!) { 
  impressao(where: {usuario_id: {_eq: \$usuario_id}}, order_by: {id: desc}) {
    id
    comentario
    status
    usuario {
      id
    }
    valor_total
    arquivo_impressaos {
      colorido
      id
      nome
      quantidade
      num_paginas
      tipo_folha {
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

  static const String posicaoAtendimento = """
subscription posicaoAtendimento(\$id: Int!) {
  atendimento_aggregate(where: {status: {_eq: 1}, _and: {id: {_gt: \$id}}}) {
    aggregate {
      count(columns: id)
    }
  }
}

""";

  static const String getListaMateriais = """query materiais {
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
    usuario {
      pessoa {
        nome
      }
      url_foto
    } 
    arquivo_materials { 
      nome
      url
      num_paginas
    }
  }
}
""";
  static const String getDetalhesUsuUsuario = """
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

  static const String getSincronizacao = """
  query valoresImpressao {
  valor_impressao {
    colorido
    data_fim
    data_inicio
    tipo_folha_id
    valor
    id
  }
  tipo_folha {
    id
    nome 
  }
}
""";

  static const String getValorMaximoImpressao = """
  query nivel_usuario(\$usuario_id: Int!) {
  nivel_usuario(where: {usuario_id: {_eq: \$usuario_id}}) {
    nivel {
      valor_max_impressao
    }
  }
}
""";

  static const String getMenus = """
query getMenus(\$usuario_id: Int!) {
  menu(where:
    {_or: [{direito_menu_tipo_usuarios: {tipo_usuario: {usuarios: {id: {_eq: \$usuario_id}}}}}, {direito_menu_usuarios: {usuario_id: {_eq: \$usuario_id}}}]}) {
    nome
    id
    menu_pai_id
  }
}
""";
}
