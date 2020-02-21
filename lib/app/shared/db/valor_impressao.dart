import 'package:floor/floor.dart';
import 'package:hive/hive.dart';

part 'valor_impressao.g.dart';

@HiveType(typeId: 2)
class ValorImpressao extends HiveObject {
  @PrimaryKey(autoGenerate: true)
  @HiveField(0)
  final int id;
  @HiveField(1)
  final double valor;
  @HiveField(2)
  final String idServer;
  @HiveField(3)
  final String tipoFolha;
  @HiveField(4)
  final DateTime dataInicio;
  @HiveField(5)
  final DateTime dataFim;
  @HiveField(6)
  final bool colorido;

  ValorImpressao(this.id, this.valor, this.tipoFolha, this.idServer,
      this.dataInicio, this.dataFim, this.colorido);
}
