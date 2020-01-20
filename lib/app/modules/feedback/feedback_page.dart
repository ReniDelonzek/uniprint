import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:uniprint/app/shared/network/graph_ql_data.dart';
import 'package:uniprint/app/shared/network/mutations.dart';
import 'package:uniprint/app/shared/utils/utils_cadastro.dart';
import 'package:uniprint/app/shared/widgets/button.dart';

class FeedbackPage extends StatefulWidget {
  final String title;
  const FeedbackPage({Key key, this.title = "Feedback"}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final controllerFeedBack = TextEditingController();
  var coutTextFeedback = 0;
  double rating = 4;

  @override
  void initState() {
    super.initState();
    controllerFeedBack.addListener(() {
      setState(() {
        coutTextFeedback = controllerFeedBack.text.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('FeedBack'),
        ),
        body: Builder(
          builder: (context) => SingleChildScrollView(
            child: new Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Sua opinião é muito importante para nós! Além do nos incentivar muito, ajuda para que possamos sempre aprimorar e entregar um serviço de melhor qualidade ❣',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: SmoothStarRating(
                          allowHalfRating: false,
                          onRatingChanged: (v) {
                            rating = v;
                            setState(() {});
                          },
                          starCount: 5,
                          rating: rating,
                          size: 40.0,
                          color: Colors.blue,
                          borderColor: Colors.blue,
                          spacing: 0.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black45),
                          labelText:
                              'Insira dicas, opiniões, críticas, desabafos...',
                          counter: Text('$coutTextFeedback/500'),
                        ),
                        maxLength: 500,
                        controller: controllerFeedBack,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Button(
                          'Enviar',
                           () async {
                             ProgressDialog progressDialog = ProgressDialog(context);
                             progressDialog.style(message: 'Enviando feedback');
                             progressDialog.show();
                            FirebaseAuth.instance.currentUser().then((user) async {
                              var res = await GraphQlObject.hasuraConnect.mutation(cadastroFeedBack, variables:
                              {
                                 'nota': rating,
                                 'feedback': controllerFeedBack.text,
                                 'usuario_id': 1
                              });
                              progressDialog.dismiss();
                              if (res != null) {
                                showSnack(context, 'Muito obrigado!', dismiss: true);
                              } else {
                                showSnack(context, 'Ops, algo saiu mal 😥');
                              }
                            }).catchError(() {
                              progressDialog.dismiss();
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Ops, algo saiu mal 😥'),
                                duration: Duration(seconds: 3),
                              ));
                            });
                          },
                        ))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
