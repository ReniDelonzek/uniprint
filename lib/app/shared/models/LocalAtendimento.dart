class LocalAtendimento {
  String nome;
  String id;
  int idServer;
}

String getLocalAtendimento(int cod) {
  switch (cod) {
    case 1:
      return "CTU";
    case 2:
      return "Sede";
    case 3:
      return "Cleve";
  }
}
