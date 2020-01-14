import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog/progress_dialog.dart';

showSnack(BuildContext context, String text, {bool dismiss}) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(text),
    duration: Duration(seconds: 2),
  ));
  if (dismiss != null && dismiss) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }
// }

// Widget tratarMutation(QueryResult result, BuildContext context, Widget widget) {
//   if (result.hasException) {
//     showSnack(context, 'Ops, houve uma falha ao tentar cadastrar');
//   }
//   if (result.loading) {
//     return Center(
//       child: CircularProgressIndicator(),
//     );
//   }
//   if (result.data != null) {
//     showSnack(context, 'Cadastro efetuado com sucesso');
//   }
//   return widget;
// }

  showProgressDialog(BuildContext context) {
    ProgressDialog progressDialog =
        ProgressDialog(context, type: ProgressDialogType.Normal);
    progressDialog.style(
        message: 'Enviando dados...',
        progressWidget: SpinKitThreeBounce(
          color: Colors.blue,
        ));
    progressDialog.show();
  }
}
