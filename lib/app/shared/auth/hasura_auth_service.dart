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
import 'package:uniprint/app/shared/utils/constans.dart';

class HasuraAuthService extends Disposable {
  UsuarioHasura usuario;
  Completer<Box> completer = Completer();

  HasuraAuthService() {
    _init();
  }

  _init() async {
    await AppModule.to.getDependency<UtilsHiveService>().inicializarHive();
    Box box = (Hive.isBoxOpen('hasura_user')
        ? Hive.box('hasura_user')
        : (await Hive.openBox('hasura_user')));
    completer.complete(box);
  }

  Future<bool> deslogar() async {
    usuario = null;
    Box box = await completer.future;
    await box.clear();

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
          snap.documents.forEach((doc) async {
            await doc.reference.delete();
          });
        });
        FirebaseAuth.instance.signOut();
        return true;
      }).catchError((error) {
        FirebaseAuth.instance.signOut();
        return false;
      });
    }).catchError((error) {
      FirebaseAuth.instance.signOut();
      return false;
    });
  }

  void obterDadosUsuario(
      String uid, ValueChanged<UsuarioHasura> onChanged) async {
    if (usuario == null) {
      Box box = await completer.future;
      if (box.containsKey('usuario')) {
        usuario = box.get('usuario');
        onChanged(usuario);
      } else {
        var l =
            Firestore.instance.collection('Usuarios').document(uid).snapshots();
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

  @override
  void dispose() {}
}
