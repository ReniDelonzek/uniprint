import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniprint/app/modules/home/home_page.dart';
import 'package:uniprint/app/modules/home/login_social/login_social_page.dart';

import 'constans.dart';

Future<bool> isLogged() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  return (user != null) ? true : false;
}

deslogar() {
  SharedPreferences.getInstance().then((shared) {
    shared.remove(Constants.TIPO_USUARIO);
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('Usuarios')
          .document(user.uid)
          .collection('tokens')
          .where('messaging_token',
              isEqualTo: shared.get(Constants.MESSAGING_TOKEN))
          .getDocuments()
          .then((snap) {
        snap.documents.forEach((doc) {
          doc.reference.delete();
        });
      });
      FirebaseAuth.instance.signOut();
    }).catchError((error) {
      FirebaseAuth.instance.signOut();
    });
  }).catchError((error) {
    FirebaseAuth.instance.signOut();
  });
}

void verificarLogin(context) {
  FirebaseAuth.instance.currentUser().then((user) async {
    if (user == null) {
      Route route = MaterialPageRoute(builder: (context) => LoginSocialPage());
      Navigator.pushReplacement(context, route);
    } else {
      _goScreen(user, context);
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
  Route route = MaterialPageRoute(builder: (context) => HomePage());
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
      } if (token.claims.containsKey('aluno')) {
        prefs.setString(Constants.RA_ALUNO, token.claims['aluno'].toString());
        prefs.setInt(Constants.TIPO_USUARIO, Constants.USUARIO_ALUNO);
        return Constants.USUARIO_ALUNO;
      } else {
        prefs.setInt(Constants.TIPO_USUARIO, Constants.USUARIO_NORMAL);
        return Constants.USUARIO_NORMAL;
      }

    } else return -1;
  } return -1;
}

void posLogin(AuthResult user, BuildContext context) async {
  if (user != null) {
    SharedPreferences.getInstance().then((shared) async {
      Firestore.instance
          .collection('Usuarios')
          .document(user.user.uid)
          .collection('tokens')
          .add({'messaging_token': shared.getString('messaging_token')});
      var usuario = await FirebaseAuth.instance.currentUser();
      _goScreen(usuario, context);
    }).catchError((error) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Ops, houve uma falha na tentativa de login"),
      ));
    });
  } else {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("Ops, houve uma falha na tentativa de login"),
    ));
  }
}
