import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uniprint/app/shared/models/graph/ponto_atendimento.dart';

class TextTitle extends StatelessWidget {
  String title;

  TextTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 0.0, left: 10, right: 16),
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 0.27,
          ),
        ));
  }
}

class MyChipButton extends StatefulWidget {
  String title;
  bool isSelect;
  GestureTapCallback onTap;

  MyChipButton(this.title, this.isSelect, this.onTap);

  @override
  State<StatefulWidget> createState() {
    return MyChipButtonState(title, isSelect, onTap);
  }
}

class MyChipButtonState extends State<MyChipButton> {
  String title;
  bool isSelect;
  GestureTapCallback onTap;

  MyChipButtonState(this.title, this.isSelect, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ChipButtonState(title, isSelect, onTap);
  }
}

Widget _textTitle(String text) {
  return Padding(
      padding: const EdgeInsets.only(top: 0.0, left: 0, right: 16),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          letterSpacing: 0.27,
        ),
      ));
}

class ChipButtonState extends StatelessWidget {
  String title;
  bool isSelected;
  GestureTapCallback onTap;

  ChipButtonState(this.title, this.isSelected, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
            color: isSelected ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            border: new Border.all(color: Colors.blue)),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.white24,
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
              onTap: onTap,
              child: Padding(
                padding:
                    EdgeInsets.only(top: 12, bottom: 12, left: 30, right: 30),
                child: Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        letterSpacing: 0.27,
                        color: isSelected ? Colors.white : Colors.blue),
                  ),
                ),
              ),
            )));
  }
}

class CabecalhoDetalhesUsuario extends StatelessWidget {
  String uid;
  bool carregar;

  CabecalhoDetalhesUsuario(this.uid, this.carregar);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _obterDados(),
      height: 100,
    );
  }

  Widget _obterDados() {
    if (carregar) {
      return FutureBuilder(
        future: Firestore.instance.collection('Usuarios').document(uid).get(),
        builder: (build, AsyncSnapshot snap) {
          switch (snap.connectionState) {
            case ConnectionState.waiting:
              return new Center(child: new RefreshProgressIndicator());
            default:
              return _getProfile(snap);
          }
        },
      );
    } else {
      return new Center(child: new RefreshProgressIndicator());
    }
  }

  _getProfile(snap) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(snap.data['foto'] ??
                'https://www.pnglot.com/pngfile/detail/192-1925683_user-icon-png-small.png')),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                snap.data['nome'] ?? "",
                overflow: TextOverflow.clip,
                maxLines: 2,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              Text(snap.data['email'], overflow: TextOverflow.ellipsis)
            ],
          ),
        )
      ],
    );
    /*} else {
      return Container(
        child: Text('Falha ao carregar perfil'),
      );
    }*/
  }
}
