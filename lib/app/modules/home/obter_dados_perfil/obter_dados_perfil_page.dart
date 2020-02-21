import 'package:flutter/material.dart';

class ObterDadosPerfilPage extends StatefulWidget {
  final String title;
  const ObterDadosPerfilPage({Key key, this.title = "ObterDadosPerfil"})
      : super(key: key);

  @override
  _ObterDadosPerfilPageState createState() => _ObterDadosPerfilPageState();
}

class _ObterDadosPerfilPageState extends State<ObterDadosPerfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
