import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:uniprint/app/shared/models/graph/atendimento_g.dart';
import 'package:uniprint/app/shared/models/graph/impressao.dart';

part 'home_controller.g.dart';

class HomeController = _HomeBase with _$HomeController;

abstract class _HomeBase with Store {
  FirebaseUser user;
  @observable
  ObservableList<Atendimento> atendimentos = ObservableList();
  @observable
  ObservableList<Impressao> impressoes = ObservableList();
  @observable
  bool exibirFab = true;
}
