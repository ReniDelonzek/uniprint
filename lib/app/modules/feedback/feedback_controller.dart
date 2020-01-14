import 'package:mobx/mobx.dart';

part 'feedback_controller.g.dart';

class FeedbackController = _FeedbackBase with _$FeedbackController;

abstract class _FeedbackBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
