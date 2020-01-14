import 'package:floor/floor.dart';

@entity
class ValorImpressao {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final double valor;

  final String idServer;

  final String tipoFolha;

  final int dataInicio;

  final int dataFim;

  final bool colorido;

  ValorImpressao(this.id, this.valor, this.tipoFolha, this.idServer,
      this.dataInicio, this.dataFim, this.colorido);
}
