import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniprint/app/shared/temas/Tema.dart';
import 'package:uniprint/app/shared/utils/utils_login.dart';
import 'package:uniprint/app/shared/utils/utils_notification.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  FirebaseMessaging _firebaseMessaging;
  int opacity = 0;
  var buildContext;
  double width = 0, height = 0;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging = FirebaseMessaging();
    _firebaseCloudMessagingListeners();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        opacity = 1;
        width = 200;
        height = 200;
      });
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        verificarLogin(buildContext);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: Tema.getTema(context),
        home: Builder(builder: ((context) {
          buildContext = context;
          return new Scaffold(
            body: new Container(
              alignment: Alignment.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedContainer(
                    duration: Duration(milliseconds: 1000),
                    width: width,
                    height: height,
                    child: AnimatedOpacity(
                      child: FlutterLogo(
                        size: 200.0,
                      ),
                      opacity: opacity.toDouble(),
                      duration: Duration(milliseconds: 1500),
                    ),
                  ),
                ],
              ),
            ),
          );
        })));
  }

  void _firebaseCloudMessagingListeners() {
    if (Platform.isIOS) _iOSPermission();
    if (Platform.isAndroid || Platform.isIOS) {
      _firebaseMessaging.getToken().then((token) {
        SharedPreferences.getInstance().then((shared) {
          String tokenAnt = shared.getString('messaging_token');
          if (token != tokenAnt) {
            shared.setString('messaging_token', token);
            FirebaseAuth.instance.currentUser().then((user) {
              if (user != null) {
                enviarToken(user.uid, context);
              }
            });
          }
        });
      });
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          showNotification(message['notification']['title'],
              message['notification']['body'], json.encode(message), context);
        },
        onBackgroundMessage: myBackgroundMessageHandler,
        onLaunch: (Map<String, dynamic> message) async {
          setActionNotification(message.toString());
        },
        onResume: (Map<String, dynamic> message) async {
          setActionNotification(message.toString());
        },
      );
    }
  }

  void _iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}

// ignore: missing_return
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  print(message);
  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic not = message['notification'];
    showNotification(not['title'], not['body'], json.encode(message), context);
  }

  // Or do other work.
}
