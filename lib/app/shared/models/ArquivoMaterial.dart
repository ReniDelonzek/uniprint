class ArquivoMaterial {
  String id;
  String url;
  String nome;
  String patch;

  Map<String, String> toMap() {
    Map<String, String> map = Map();
    map["nome"] = nome;
    map["url"] = url;
    return map;
  }
}
