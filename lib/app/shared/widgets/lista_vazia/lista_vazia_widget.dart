import 'package:flutter/material.dart';

class ListaVaziaWidget extends StatelessWidget {
  final String mensagem1;
  final String mensagem2;
  final String asset;
  const ListaVaziaWidget(this.mensagem1, this.mensagem2, this.asset);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            asset,
            width: 120,
            height: 120,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 2),
            child: Text(
              mensagem1,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(mensagem2)
        ],
      ),
    );
  }
}
