import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniprint/app/app_module.dart';
import 'package:uniprint/app/shared/db/hive/usuario.dart';
import 'package:uniprint/app/shared/db/hive/utils_hive_service.dart';
import 'package:uniprint/app/shared/interfaces/auth_service_interface.dart';
import 'package:uniprint/app/shared/network/graph_ql_data.dart';
import 'package:uniprint/app/shared/utils/constans.dart';
import 'package:uniprint/app/shared/utils/utils_sentry.dart';

class HasuraAuthService extends Disposable with AuthServiceInterface {
  FirebaseUser firebaseUser;
  UsuarioHasura usuario;
  Completer<Box> completer = Completer();

  HasuraAuthService() {
    _init();
  }

  _init() async {
    await AppModule.to.getDependency<UtilsHiveService>().inicializarHive();
    Box box = await AppModule.to
        .getDependency<UtilsHiveService>()
        .getBox('hasura_user');
    completer.complete(box);
  }

  @override
  Future<bool> logOut() async {
    try {
      usuario = null;
      firebaseUser = await FirebaseAuth.instance.currentUser();
      Box box = await completer.future;
      await box.clear();
      await FirebaseAuth.instance.signOut();

      SharedPreferences shared = await SharedPreferences.getInstance();
      shared.remove(Constants.TIPO_USUARIO);
      await _limparTokenFirebase(
          firebaseUser?.uid, shared.get(Constants.MESSAGING_TOKEN));
      GraphQlObject.hasuraConnect.cleanCache();
      Box boxMenu =
          await AppModule.to.getDependency<UtilsHiveService>().getBox('menu');
      boxMenu.clear();
      return true;
    } catch (error, stackTrace) {
      UtilsSentry.reportError(error, stackTrace);
      return false;
    }
  }

  void obterDadosUsuario(
      FirebaseUser firebaseUser, ValueChanged<UsuarioHasura> onChanged) async {
    this.firebaseUser = firebaseUser;
    if (usuario == null) {
      Box box = await completer.future;
      if (box.containsKey('usuario')) {
        usuario = box.get('usuario');
        onChanged(usuario);
      } else {
        var l = Firestore.instance
            .collection('Usuarios')
            .document(firebaseUser.uid)
            .snapshots();
        l.listen((event) async {
          if (event.data?.containsKey('hasura_id') ?? false) {
            if (usuario == null) {
              usuario = UsuarioHasura();
            }
            usuario.codHasura = event.data['hasura_id'];
            if (event.data?.containsKey('cod_professor') ?? false) {
              usuario.codHasura = event.data['cod_professor'];
            }
            completer.future.then((box) {
              box.put('usuario', usuario);
              onChanged(usuario);
            }).catchError((error) {
              print(error);
              onChanged(null);
            });
          }
        });
      }
    } else {
      onChanged(usuario);
    }
  }

  _limparTokenFirebase(String uid, String token) {
    Firestore.instance
        .collection('Usuarios')
        .document(uid)
        .collection('tokens')
        .where('messaging_token', isEqualTo: token)
        .getDocuments()
        .then((snap) {
      snap.documents.forEach((doc) async {
        await doc.reference.delete();
      });
    });
  }

  @override
  void dispose() {}
}
