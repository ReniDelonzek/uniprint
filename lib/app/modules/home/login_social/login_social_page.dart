import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uniprint/app/modules/home/login_email/login_email_page.dart';
import 'package:uniprint/app/shared/utils/utils_colors.dart';
import 'package:uniprint/app/shared/utils/utils_login.dart';

class LoginSocialPage extends StatefulWidget {
  final String title;
  const LoginSocialPage({Key key, this.title = "LoginSocial"})
      : super(key: key);

  @override
  _LoginSocialPageState createState() => _LoginSocialPageState();
}

class _LoginSocialPageState extends State<LoginSocialPage> {
 BuildContext buildContext;
  GoogleSignInAccount googleAccount;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: Builder(
      builder: (context) {
        buildContext = context;
        return new Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('imagens/back_login.jpg'),
                  fit: BoxFit.cover),
            ),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new ButtonTheme(
                    height: 45,
                    minWidth: 250,
                    child: RaisedButton(
                      onPressed: () {
                        startingLoginFacebook(context);
                      },
                      color: Color(UtilsColors.hexToInt("FF2A5F8E")),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: new Text(
                        "FACEBOOK",
                        style: new TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
                new Padding(padding: EdgeInsets.all(8)),
                new ButtonTheme(
                    height: 45,
                    minWidth: 250,
                    child: RaisedButton(
                      onPressed: () {
                        signInWithGoogle();
                      },
                      color: Color(UtilsColors.hexToInt("FFDC4E41")),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: new Text(
                        "GOOGLE",
                        style: new TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
                new Padding(padding: EdgeInsets.all(8)),
                new ButtonTheme(
                    height: 45,
                    minWidth: 250,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new LoginEmailPage()));
                      },
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: new Text(
                        "EMAIL",
                        style: new TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ))
              ],
            ));
      },
    ));
  }

  Future<Null> signInWithGoogle() async {
    try {
    if (googleAccount == null) {
      // Start the sign-in process:
      googleAccount = await googleSignIn.signIn();
      
    }
    googleAccount.authentication.then((googleAuth) {
      AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      FirebaseAuth.instance.signInWithCredential(credential).then((user) {
        if (user != null) {
          posLogin(user, buildContext);
        } else {
          Scaffold.of(buildContext).showSnackBar(new SnackBar(
            content: new Text("Ops, houve uma falha na tentativa de login"),
          ));
        }
      }).catchError((error) {
        FirebaseAuth.instance.signOut();
        Scaffold.of(buildContext).showSnackBar(new SnackBar(
          content: new Text("Ops, houve uma falha na tentativa de login"),
        ));
      });
    }).catchError((error) {
      Scaffold.of(buildContext).showSnackBar(new SnackBar(
        content: new Text("Ops, houve uma falha na tentativa de login"),
      ));
    });
    } catch (e) {
      Scaffold.of(buildContext).showSnackBar(new SnackBar(
        content: new Text("Ops, houve uma falha na tentativa de login (${e.toString()})"),
      ));
    }
    //AuthResult user = await signIntoFirebase(googleAccount);
  }

  Future<Null> initUser() async {
    googleAccount = await getSignedInAccount(googleSignIn);
    if (googleAccount == null) {
    } else {
      await signInWithGoogle();
    }
  }

  Future<GoogleSignInAccount> getSignedInAccount(
      GoogleSignIn googleSignIn) async {
    GoogleSignInAccount account = googleSignIn.currentUser;
    if (account == null) {
      account = await googleSignIn.signInSilently();
    }
    return account;
  }

  // ignore: missing_return
  Future<AuthResult> signIntoFirebase(
      GoogleSignInAccount googleSignInAccount) {}

  startingLoginFacebook(BuildContext context) async {
    var facebookLogin = new FacebookLogin();
    var result = await facebookLogin
        .logInWithReadPermissions(['email', 'public_profile']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);
        FirebaseAuth.instance
            .signInWithCredential(credential)
            .catchError((Object error) {
          if ((error as PlatformException).code ==
              'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
            Scaffold.of(buildContext).showSnackBar(new SnackBar(
              content: new Text(
                  "Ops, parece que você já fez login nesse email com outro tipo de autenticação"),
            ));
          } else {
            Scaffold.of(buildContext).showSnackBar(new SnackBar(
              content: new Text("Ops, houve uma falha na tentativa de login"),
            ));
          }
        }).then((user) {
          posLogin(user, buildContext);
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("O login foi cancelado");
        break;
      case FacebookLoginStatus.error:
        Scaffold.of(buildContext).showSnackBar(new SnackBar(
          content: new Text("Ops, houve uma falha na tentativa de login"),
        ));
        print("Houve um erro");
        break;
    }
  }
}
