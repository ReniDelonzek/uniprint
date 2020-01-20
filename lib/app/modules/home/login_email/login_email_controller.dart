import 'package:mobx/mobx.dart';

part 'login_email_controller.g.dart';

class LoginEmailController = _LoginEmailBase with _$LoginEmailController;

abstract class _LoginEmailBase with Store {
  @observable
  bool obscure = true;
}
