import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uniprint/app/modules/home/home_page.dart';
import 'package:uniprint/app/shared/models/Atendimento.dart';
import 'package:uniprint/app/shared/utils/utils_login.dart';

import 'constans.dart';

BuildContext context;

void showNotification(
    String title, String body, String action, BuildContext buildContext) {
  context = buildContext;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('ic_launcher');
  var initializationSettingsIOS = new IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  var initializationSettings = new InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelectNotification);

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '1', 'CHANNEL', 'Teste',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics,
      payload: action);
}

String getAction(var message) {
  if (message.containsKey('data')) {
    return message['data']['action'];
  }
  return '';
}

Future setActionNotification(String payload) async {
  // var logado = await isLogged() ?? false;
  // if (logado) {
  //   var j = json.decode(payload);
  //   String action = getAction(j);
  //   if (action == Constants.NOFITICACAO_CHAMADA_ATENDIMENTO.toString()) {
  //     Firestore.instance
  //         .collection('Empresas')
  //         .document(j['empresaID'])
  //         .collection('Pontos')
  //         .document(j['pontoID'])
  //         .collection('Atendimentos')
  //         .document(j['atendimentoID'])
  //         .get()
  //         .then((doc) {
  //       if (doc.exists) {
  //         Atendimento atendimento = Atendimento.fromJson(doc.data);
  //         if (atendimento != null) {
  //           atendimento.id = doc.documentID;
  //           Navigator.of(context).push(new MaterialPageRoute(
  //               builder: (BuildContext context) =>
  //                   new MainPrinter(atendimento: atendimento)));
  //         } else {
  //           openMainScreen();
  //         }
  //       } else {
  //         openMainScreen();
  //       }
  //     }).catchError((error) {
  //       openMainScreen();
  //     });
  //   }
  // }
}

void openMainScreen() {
  Navigator.of(context).push(
      new MaterialPageRoute(builder: (BuildContext context) => new HomePage()));
}

Future onSelectNotification(String payload) async {
  if (getAction(payload).isNotEmpty) {
    setActionNotification(payload);
  }
}

Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
  if (getAction(payload).isNotEmpty) {
    setActionNotification(payload);
  }

  // display a dialog with the notification details, tap ok to go to another page
  /*showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Route route =
                  MaterialPageRoute(builder: (context) => MainPrinter());
              Navigator.pushReplacement(context, route);
            },
          )
        ],
      ),
    );*/
}
