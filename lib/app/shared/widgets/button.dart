import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color color;
  final double width;

  Button(this.title, this.onTap, {this.color, this.width = 150});

  @override
  Widget build(BuildContext context) {
    return new ButtonTheme(
      minWidth: width,
      height: 42,
      child: new RaisedButton(
          color: color ?? Colors.blue,
          onPressed: onTap,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          child: new Text(
            title,
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}
