import 'package:uniprint/app/modules/home/obter_dados_perfil/obter_dados_perfil_controller.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:uniprint/app/modules/home/home_controller.dart';
import 'package:uniprint/app/modules/home/login_email/login_email_controller.dart';
import 'package:uniprint/app/modules/home/login_social/login_social_controller.dart';
import 'package:uniprint/app/modules/home/splash_screen/splash_screen_controller.dart';
import 'package:uniprint/app/modules/home/splash_screen/splash_screen_page.dart';
import 'package:uniprint/app/modules/home/tela_perfil/cadastro_aluno/cadastro_aluno_controller.dart';
import 'package:uniprint/app/modules/home/tela_perfil/tela_perfil_controller.dart';

class HomeModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => ObterDadosPerfilController()),
        Bloc((i) => CadastroAlunoController()),
        Bloc((i) => TelaPerfilController()),
        Bloc((i) => LoginEmailController()),
        Bloc((i) => LoginSocialController()),
        Bloc((i) => SplashScreenController()),
        Bloc((i) => HomeController()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => SplashScreenPage();

  static Inject get to => Inject<HomeModule>.of();
}
