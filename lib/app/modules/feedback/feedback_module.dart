import 'package:uniprint/app/modules/feedback/feedback_controller.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:uniprint/app/modules/feedback/feedback_page.dart';

class FeedbackModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => FeedbackController()),
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => FeedbackPage();

  static Inject get to => Inject<FeedbackModule>.of();
}
