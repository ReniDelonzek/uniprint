import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uniprint/app/app_module.dart';

import 'app/shared/utils/utils_sentry.dart';

void main() {
  runZoned<Future<void>>(() async {
    runApp(AppModule());
    UtilsSentry.configureSentry();
  }, onError: UtilsSentry.reportError);
}
