import 'package:flutter/material.dart';
import 'package:uniprint/app/shared/temas/tema.dart';

import 'modules/home/splash_screen/splash_module.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniPrint',
      theme: Tema.getTema(context),
      darkTheme: Tema.getTema(context, darkMode: true),
      themeMode: ThemeMode.dark,
      home: SplashModule(),
    );
  }
}
