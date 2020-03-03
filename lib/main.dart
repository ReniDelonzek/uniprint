import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uniprint/app/app_module.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;

import 'app/shared/utils/utils_sentry.dart';

void _setTargetPlatformForDesktop() {
  // No need to handle macOS, as it has now been added to TargetPlatform.
  if (!Foundation.kIsWeb && (Platform.isLinux || Platform.isWindows)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  _setTargetPlatformForDesktop();
  runZoned<Future<void>>(() async {
    runApp(AppModule());
    UtilsSentry.configureSentry();
  }, onError: UtilsSentry.reportError);
}
