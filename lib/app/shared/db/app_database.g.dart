// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final database = _$AppDatabase();
    database.database = await database.open(
      name ?? ':memory:',
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ValorImpressaoDao _valorImpressaoDaoInstance;

  Future<sqflite.Database> open(String name, List<Migration> migrations,
      [Callback callback]) async {
    final path = join(await sqflite.getDatabasesPath(), name);

    return sqflite.openDatabase(
      path,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ValorImpressao` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `valor` REAL, `idServer` TEXT, `tipoFolha` TEXT, `dataInicio` INTEGER, `dataFim` INTEGER, `colorido` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
  }

  @override
  ValorImpressaoDao get valorImpressaoDao {
    return _valorImpressaoDaoInstance ??=
        _$ValorImpressaoDao(database, changeListener);
  }
}

class _$ValorImpressaoDao extends ValorImpressaoDao {
  _$ValorImpressaoDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _valorImpressaoInsertionAdapter = InsertionAdapter(
            database,
            'ValorImpressao',
            (ValorImpressao item) => <String, dynamic>{
                  'id': item.id,
                  'valor': item.valor,
                  'idServer': item.idServer,
                  'tipoFolha': item.tipoFolha,
                  'dataInicio': item.dataInicio,
                  'dataFim': item.dataFim,
                  'colorido': item.colorido ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _valorImpressaoMapper = (Map<String, dynamic> row) =>
      ValorImpressao(
          row['id'] as int,
          row['valor'] as double,
          row['idServer'] as String,
          row['tipoFolha'] as String,
          row['dataInicio'] as int,
          row['dataFim'] as int,
          (row['colorido'] as int) != 0);

  final InsertionAdapter<ValorImpressao> _valorImpressaoInsertionAdapter;

  @override
  Future<List<ValorImpressao>> findAllPersons() async {
    return _queryAdapter.queryList('SELECT * FROM ValorImpressao',
        mapper: _valorImpressaoMapper);
  }

  @override
  Future<ValorImpressao> getImpressao(
      String tipo, int dataInicio, int dataFim, int colorido) async {
    return _queryAdapter.query(
        'SELECT * FROM ValorImpressao V WHERE V.TIPOFOLHA = ? AND V.DATAINICIO < ? AND (V.DATAFIM > ? OR V.DATAFIM = 0) AND V.COLORIDO = ? LIMIT 1',
        arguments: <dynamic>[tipo, dataInicio, dataFim, colorido],
        mapper: _valorImpressaoMapper);
  }

  @override
  Future<List<int>> inserirValores(List<ValorImpressao> valores) {
    return _valorImpressaoInsertionAdapter.insertListAndReturnIds(
        valores, sqflite.ConflictAlgorithm.abort);
  }
}
