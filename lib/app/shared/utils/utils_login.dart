import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniprint/app/app_module.dart';
import 'package:uniprint/app/modules/home/home_module.dart';
import 'package:uniprint/app/modules/home/home_page.dart';
import 'package:uniprint/app/modules/home/login_social/login_social_page.dart';
import 'package:uniprint/app/shared/auth/hasura_auth_service.dart';
import 'package:uniprint/app/shared/db/hive/usuario.dart';
import 'package:uniprint/app/shared/utils/utils_cadastro.dart';

import 'constans.dart';

Future<bool> isLogged() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  return (user != null) ? true : false;
}

void verificarLogin(context) {
  FirebaseAuth.instance.currentUser().then((user) async {
    if (user == null) {
      Route route = MaterialPageRoute(builder: (context) => LoginSocialPage());
      Navigator.pushReplacement(context, route);
    } else {
      AppModule.to
          .getDependency<HasuraAuthService>()
          .obterDadosUsuario(user.uid, (value) {
        _goScreen(user, context);
      });
    }
  }).catchError((onError) {
    print(onError);
  });
}

Future<String> _getPontoAtendimento(String userId) async {
  DocumentSnapshot doc =
      await Firestore.instance.collection('Atendentes').document(userId).get();
  if (doc != null && doc.exists) {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('codPonto', doc.data['codPonto']);
    return doc.data['codPonto'];
  } else {
    return null;
  }
}

void _goScreen(FirebaseUser user, BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();

  int tipo = 0;
  if (prefs.containsKey(Constants.TIPO_USUARIO)) {
    tipo = prefs.getInt(Constants.TIPO_USUARIO);
    atualizarPermissoes(user, prefs);
  } else
    tipo = await atualizarPermissoes(user, prefs);

  // if (tipo == Constants.USUARIO_ATENDENTE) {
  //   String codPonto = await _getPontoAtendimento(user.uid);
  //   Route route =
  //       MaterialPageRoute(builder: (context) => MainPrinterClerk(codPonto));
  //   Navigator.pushReplacement(context, route);
  // } else {
  Route route = MaterialPageRoute(builder: (context) => HomeModule());
  Navigator.pushReplacement(context, route);
  //}
}

Future<int> atualizarPermissoes(
    FirebaseUser user, SharedPreferences prefs) async {
  if (user != null) {
    IdTokenResult token = await user.getIdToken(refresh: true);
    if (token != null) {
      if (token.claims.containsKey('professor')) {
        prefs.setInt(Constants.TIPO_USUARIO, Constants.USUARIO_PROFESSOR);
        return Constants.USUARIO_PROFESSOR;
      }
      if (token.claims.containsKey('aluno')) {
        prefs.setString(Constants.RA_ALUNO, token.claims['aluno'].toString());
        prefs.setInt(Constants.TIPO_USUARIO, Constants.USUARIO_ALUNO);
        return Constants.USUARIO_ALUNO;
      } else {
        prefs.setInt(Constants.TIPO_USUARIO, Constants.USUARIO_NORMAL);
        return Constants.USUARIO_NORMAL;
      }
    } else
      return -1;
  }
  return -1;
}

Future<bool> enviarToken(String uid, BuildContext context) {
  SharedPreferences.getInstance().then((shared) async {
    Firestore.instance
        .collection('Usuarios')
        .document(uid)
        .collection('tokens')
        .add({'messaging_token': shared.getString('messaging_token')});
    return true;
  }).catchError((error) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("Ops, houve uma falha na tentativa de login"),
    ));
    return false;
  });
}

void posLogin(AuthResult user, BuildContext context) async {
  if (user != null) {
    enviarToken(user.user.uid, context);
    buscarDadosPerfil(context, user.user.uid);
  } else {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("Ops, houve uma falha na tentativa de login"),
    ));
  }
}

void buscarDadosPerfil(BuildContext context, String uid) async {
  ProgressDialog progressDialog = ProgressDialog(context)
    ..style(message: 'Buscando dados do perfil')
    ..show();

  HasuraAuthService hasuraAuthService =
      AppModule.to.getDependency<HasuraAuthService>();
  hasuraAuthService.obterDadosUsuario(uid, (UsuarioHasura usuarioHasura) async {
    try {
      progressDialog.dismiss();
    } catch (e) {
      print(e);
    }
    if (usuarioHasura != null) {
      var usuario = await FirebaseAuth.instance.currentUser();
      _goScreen(usuario, context);
    } else {
      showSnack(context,
          'Houve uma falha ao tentar recuperar os dados de usuário, tente novamente');
    }
  });
}
