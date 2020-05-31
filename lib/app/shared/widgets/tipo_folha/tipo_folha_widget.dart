import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:uniprint/app/app_module.dart';
import 'package:uniprint/app/shared/db/hive/tipo_folha.dart';
import 'package:uniprint/app/shared/widgets/tipo_folha/tipo_folha_controller.dart';
import 'package:uniprint/app/shared/widgets/widgets.dart';

class TipoFolhaWidget extends StatelessWidget {
  final TipoFolhaController _controller;

  const TipoFolhaWidget(this._controller);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _textTitle('Tipo de folha'),
          AppModule.to.getDependency<TipoFolha>().tiposFolha != null
              ? _listaItens(AppModule.to.getDependency<TipoFolha>().tiposFolha)
              : FutureBuilder(
                  future: _controller.getTiposFolha(),
                  builder: (_, snap) {
                    if (snap.connectionState != ConnectionState.done) {
                      return Text('');
                    } else {
                      List<TipoFolha> tipos = snap.data;
                      return _listaItens(tipos);
                    }
                  },
                ),
        ]);
  }

  _listaItens(List<TipoFolha> tipos) {
    return Observer(
      builder: (_) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: tipos
              .map((element) => ChipButtonState(
                      element.nome, _controller.tipoFolha?.id == element.id,
                      () {
                    _controller.tipoFolha = element;
                  }))
              .toList()),
    );
  }

  Widget _textTitle(String text) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 15.0, left: 10, right: 10, bottom: 10),
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            //letterSpacing: 0.27,
          ),
        ));
  }
}
