import 'package:flutter/material.dart';

import 'modules/home/splash_screen/splash_module.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniPrint',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashModule(),
    );
  }
}
