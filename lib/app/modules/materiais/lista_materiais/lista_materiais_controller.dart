import 'package:mobx/mobx.dart';
import 'package:uniprint/app/shared/models/graph/materiais/material.dart'; 
part 'lista_materiais_controller.g.dart';

class ListaMateriaisController = _ListaMateriaisBase
    with _$ListaMateriaisController;

abstract class _ListaMateriaisBase with Store {
  @observable
  ObservableList<MaterialProf> materiais = ObservableList();
}
