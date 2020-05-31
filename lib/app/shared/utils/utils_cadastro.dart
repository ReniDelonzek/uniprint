import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog/progress_dialog.dart';

Future<bool> showSnack(BuildContext context, String text,
    {bool dismiss, dynamic data, Duration duration}) async {
  try {
    FocusScope.of(context).requestFocus(FocusNode());
    if (text != null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(text),
        duration: duration ?? Duration(seconds: 2),
      ));
    }
    await Future.delayed(duration ?? Duration(seconds: 2));
    if (dismiss != null && dismiss) {
      NavigatorState nav = Navigator.of(context);
      if (nav != null && nav.canPop()) {
        nav?.pop(data);
      }
    }
    return true;
  } catch (error) {
    //UtilsSentry.reportError(error,stackTrace,);
    return false;
  }
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
