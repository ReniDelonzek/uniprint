import 'dart:async';

import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:uniprint/app/shared/db/ValorImpressao.dart';
import 'package:uniprint/app/shared/db/dao/ValorImpressao_dao.dart';
 
part 'app_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [ValorImpressao])
abstract class AppDatabase extends FloorDatabase {
  ValorImpressaoDao get valorImpressaoDao;
}

Future<AppDatabase> getDataBase() async {
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  return database;
}
