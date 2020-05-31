import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

part 'feedback_controller.g.dart';

class FeedbackController = _FeedbackBase with _$FeedbackController;

abstract class _FeedbackBase with Store {
  final controllerFeedBack = TextEditingController();
  @observable
  int coutTextFeedback = 0;
  @observable
  double rating = 4;

  _FeedbackBase() {
    controllerFeedBack.addListener(() {
      coutTextFeedback = controllerFeedBack.text.length;
    });
  }
}
