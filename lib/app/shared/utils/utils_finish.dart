import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class UtilsFinish {
  UtilsFinish();

  static void finishScreen(BuildContext context, String message) {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(message), duration: Duration(seconds: 2)));
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
    });
  }
}
