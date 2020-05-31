import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uniprint/app/shared/db/hive/tipo_folha.dart';
import 'package:uniprint/app/shared/db/hive/usuario.dart';
import 'package:uniprint/app/shared/db/valor_impressao.dart';

class UtilsHiveService extends Disposable {
  Completer<bool> completer = Completer();

  UtilsHiveService() {
    _init();
  }

  _init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UsuarioHasuraAdapter());
    Hive.registerAdapter(ValorImpressaoAdapter());
    Hive.registerAdapter(TipoFolhaAdapter());
    completer.complete(true);
  }

  Future<bool> inicializarHive() async {
    if (!completer.isCompleted) {
      return await completer.future;
    } else
      return true;
  }

  Future<Box<E>> getBox<E>(String name) async {
    if (!completer.isCompleted) {
      await completer.future;
    }
    return (Hive.isBoxOpen(name)) ? Hive.box<E>(name) : Hive.openBox<E>(name);
  }

  @override
  void dispose() {
    completer.future.then((value) => {Hive.close()});
  }
}
