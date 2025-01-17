import 'package:firebase_auth/firebase_auth.dart';
import 'package:hasura_connect/hasura_connect.dart';

class GraphQlObject {
  static HasuraConnect hasuraConnect =
      HasuraConnect('http://159.89.146.96/v1/graphql', token: (isError) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      String token = (await user.getIdToken())?.token;
      return "Bearer $token";
    } else
      return "";
  });
}

validarRespostaQuery(var res, String chave, {bool podeSerVazia = true}) {
  if (res != null) {
    try {
      Map map = res;
      if (map.containsKey('data') && map['data'].containsKey(chave)) {
        if (podeSerVazia == false) {
          return map['data'][chave] != null && !(map['data'][chave].isEmpty);
        }
        return true;
      }
    } catch (error, _) {
      print(error);
      //UtilsSentry.reportError(error, stackTrace, data: chave);
    }
  }
  return false;
}

List<int> obterIdsResposta(var res, String chave) {
  try {
    return List<int>.from(
        res['data'][chave]['returning'].map((e) => (e['id'] as int)).toList());
  } catch (error) {
    print(error);
  }
  return null;
}

bool sucessoMutationAffectRows(var res, String chave) {
  try {
    return res['data'][chave]['affected_rows'] != 0;
  } catch (error) {
    print(error);
  }
  return null;
}

dynamic getValorLinha(var res, String chave, String variavel) {
  try {
    return res['data'][chave][variavel];
  } catch (error) {
    print(error);
  }
  return null;
}
