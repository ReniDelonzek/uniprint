import 'package:floor/floor.dart';

import '../ValorImpressao.dart';

@dao
abstract class ValorImpressaoDao {
  @Query('SELECT * FROM ValorImpressao')
  Future<List<ValorImpressao>> findAllPersons();

  @Query(
      'SELECT * FROM ValorImpressao V WHERE V.TIPOFOLHA = :tipo AND V.DATAINICIO < :dataInicio AND (V.DATAFIM > :dataFim OR V.DATAFIM = 0) AND V.COLORIDO = :colorido LIMIT 1')
  Future<ValorImpressao> getImpressao(
      String tipo, int dataInicio, int dataFim, int colorido);

  @insert
  Future<List<int>> inserirValores(List<ValorImpressao> valores);
}
