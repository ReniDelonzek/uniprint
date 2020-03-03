import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:uniprint/app/modules/home/login_email/login_email_controller.dart';
import 'package:uniprint/app/modules/home/splash_screen/splash_screen_controller.dart';
import 'package:uniprint/app/modules/home/splash_screen/splash_screen_page.dart';

class SplashModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => SplashScreenController()),
        Bloc((i) => LoginEmailController()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => SplashScreenPage();

  static Inject get to => Inject<SplashModule>.of();
}
