import 'package:uniprint/app/shared/utils/constans.dart';

class Mutations {
  static const String cadastroAtendimento =
      """mutation addAtendimentos(\$data: timestamptz!, \$tipo: Int!, \$usuario_id: Int!, \$ponto_atendimento_id: Int!, \$status: Int!) {
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

  static const String cadastroImpressao =
      """mutation addImpressao(\$data: timestamptz!, \$usuario_id: Int!, \$tipo: Int!,
  \$comentario: String!, \$ponto_atendimento_id: Int!, \$arquivos: [arquivo_impressao_insert_input!]!) {
  insert_movimentacao(objects: {
    data: \$data,
    usuario_id: \$usuario_id, 
    tipo: \$tipo,
    movimentacao_impressaos: {data: {
      impressao: {data: {
        comentario: \$comentario,
        status: ${Constants.STATUS_IMPRESSAO_SOLICITADO}, 
        usuario_id: \$usuario_id,
        ponto_atendimento_id: \$ponto_atendimento_id,
        arquivo_impressaos: {data: \$arquivos}},
      
      }}}}) {
    affected_rows
  }
}
""";

  static const String cadastroFeedBack = """
mutation AddFeedbak(\$feedback: String!, \$nota: float8!, \$usuario_id: Int!) {
  __typename
  insert_feedback(objects: {feedback: \$feedback, nota: \$nota, usuario_id: \$usuario_id}) {
    affected_rows
  }
}
""";

  static const String cadastroMaterial =
      """mutation AddMaterial(\$colorido: Boolean!, \$data_publicacao: timestamptz!, 
\$tipo: Int!, \$tipo_folha_id: Int!, \$titulo: String!, \$arquivos: [arquivo_material_insert_input!]!, \$usuario_id: Int!, \$descricao: String) {
  insert_material(objects: {usuario_id: \$usuario_id, colorido: \$colorido, data_publicacao: \$data_publicacao, tipo: \$tipo,
   tipo_folha_id: \$tipo_folha_id, titulo: \$titulo, descricao: \$descricao arquivo_materials: {data: \$arquivos}}) {
    affected_rows
  }
}
""";

  static const String cadastroAtendente = """
mutation AddAtendente(\$usuario_id: Int!, \$ponto_atendimento_id: Int!) {
  __typename
  insert_atendente(objects: {usuario_id: \$usuario_id, ponto_atendimento_id: \$ponto_atendimento_id}) {
    affected_rows
  }
}
""";

  static const String addMovimentacaoAtendimento = """
mutation AddMovimentacaoAtendimento(\$atendimento_id: Int!, \$status: Int!, 
\$data: timestamptz!, \$tipo_movimento: Int!, \$usuario_id: Int!) {
  update_atendimento(where: {id: {_eq: \$atendimento_id}}, _set: {status: \$status}) {
    affected_rows
  }
  insert_movimentacao(objects: {data: \$data, tipo: \$tipo_movimento, usuario_id: \$usuario_id, 
    movimentacao_atendimentos: {data: {atendimento_id: \$atendimento_id}}}) {
    affected_rows
  }
}

""";

  static const String cadastroMovimentacaoAtendimento = """
mutation cadastroMovimentacaoAtendimento(\$data: timestamptz!, 
\$tipo: Int!, \$usuario_id: Int!, \$atendimento_id: Int!, \$status: Int!) {
  insert_movimentacao(objects: {data: \$data, 
    tipo: \$tipo, 
    usuario_id: \$usuario_id, 
    movimentacao_atendimentos: {data: {atendimento_id: \$atendimento_id}}}) {
    affected_rows
  }
  update_atendimento(_set: {status: \$status}, where: {id: {_eq: \$atendimento_id}}) {
    affected_rows
  }
}
""";

  static const String cadastroMovimentacaoImpressao = """
mutation cadastroMovimentacaoImpressao(\$data: timestamptz!, \$tipo: Int!, \$usuario_id: Int!, \$impressao_id: Int!, \$status: Int!) {
  insert_movimentacao(objects: {data: \$data, tipo: \$tipo, usuario_id: \$usuario_id, movimentacao_impressaos: {data: {impressao_id: \$impressao_id}}}) {
    affected_rows
  }
  update_impressao(_set: {status: \$status}, where: {id: {_eq: \$impressao_id}}) {
    affected_rows
  }
}
""";

  static const String cadastroNotaAtendimento = """
mutation cadastroNotaAtendimento(\$id: Int, \$nota_atendimento: Int) {
  update_atendimento(where: {id: {_eq: \$id}}, _set: {nota_atendimento: \$nota_atendimento}) {
    affected_rows
  }
}

""";
}
