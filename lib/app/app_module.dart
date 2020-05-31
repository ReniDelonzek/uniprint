import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:uniprint/app/app_controller.dart';
import 'package:uniprint/app/app_widget.dart';
import 'package:uniprint/app/services/sincronizar_dados_service.dart';
import 'package:uniprint/app/shared/auth/hasura_auth_service.dart';
import 'package:uniprint/app/shared/db/hive/tipo_folha.dart';
import 'package:uniprint/app/shared/db/hive/utils_hive_service.dart';
import 'package:uniprint/app/shared/widgets/lista_vazia/lista_vazia_controller.dart';

class AppModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => ListaVaziaController()),
        Bloc((i) => AppController()),
      ];

  @override
  List<Dependency> get dependencies => [
        Dependency((i) => SincronizarDadosService()),
        Dependency((i) => UtilsHiveService()),
        Dependency((i) => HasuraAuthService()),
        Dependency((i) => TipoFolha()),
      ];

  @override
  Widget get view => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
