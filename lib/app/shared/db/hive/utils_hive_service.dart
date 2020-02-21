import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uniprint/app/shared/db/hive/usuario.dart';

class UtilsHiveService extends Disposable {
  Completer<bool> completer = Completer();

  UtilsHiveService() {
    _init();
  }

  _init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UsuarioHasuraAdapter());
    completer.complete(true);
  }

  Future<bool> inicializarHive() async {
    return await completer.future;
  }

  Future<Box> getBox(String name) async {
    if (!completer.isCompleted) {
      await completer.future;
    }
    return (Hive.isBoxOpen(name)) ? Hive.box(name) : Hive.openBox(name);
  }

  @override
  void dispose() {}
}
