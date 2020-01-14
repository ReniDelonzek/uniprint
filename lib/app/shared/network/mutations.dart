String cadastroAtendimento =
    """mutation addAtendimentos(\$data: timestamp!, \$tipo: Int!, \$usuario_id: Int!, \$ponto_atendimento_id: Int!, \$status: Int!) {
  insert_movimentacao(objects: 
    {data: \$data, 
      tipo: \$tipo, 
      usuario_id: \$usuario_id, 
      movimentacao_atendimentos: {
        data: {
          atendimento: {
            data: {
              data_solicitacao: \$data, 
              ponto_atendimento_id: \$ponto_atendimento_id, 
              status: \$status, 
              usuario_id: \$usuario_id
            }}}}}) {
    affected_rows
  }
}
""";

String cadastroImpressao =
    """mutation addImpressao(\$data: timestamp!, \$usuario_id: Int!, \$tipo: Int!,
  \$comentario: String!, \$arquivos: [arquivo_impressao_insert_input!]!) {
  insert_movimentacao(objects: {
    data: \$data,
    usuario_id: \$usuario_id, 
    tipo: \$tipo,
    movimentacao_impressaos: {data: {
      impressao: {data: {
        comentario: \$comentario,
        status: 10, 
        arquivo_impressaos: {data: \$arquivos}},
      
      }}}}) {
    affected_rows
  }
}
""";

String cadastroFeedBack = """
mutation AddFeedbak(\$feedback: String!, \$nota: float8!, \$usuario_id: Int!) {
  __typename
  insert_feedback(objects: {feedback: \$feedback, nota: \$nota, usuario_id: \$usuario_id}) {
    affected_rows
  }
}
""";

String cadastroMaterial =
    """mutation AddMaterial(\$colorido: Boolean!, \$data_publicacao: date!, 
\$tipo: Int!, \$tipo_folha_id: Int!, \$titulo: String!, \$arquivos: [arquivo_material_insert_input!]!) {
  __typename
  insert_material(objects: {colorido: \$colorido, data_publicacao: \$data_publicacao, tipo: \$tipo,
   tipo_folha_id: \$tipo_folha_id, titulo: \$titulo, arquivo_materials: {data: \$arquivos}}) {
    affected_rows
  }
}
""";

String cadastroAtendente = """
mutation AddAtendente(\$usuario_id: Int!, \$ponto_atendimento_id: Int!) {
  __typename
  insert_atendente(objects: {usuario_id: \$usuario_id, ponto_atendimento_id: \$ponto_atendimento_id}) {
    affected_rows
  }
}
""";
