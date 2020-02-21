import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'obter_dados_perfil_controller.g.dart';

class ObterDadosPerfilController = _ObterDadosPerfilBase
    with _$ObterDadosPerfilController;

abstract class _ObterDadosPerfilBase with Store {}
