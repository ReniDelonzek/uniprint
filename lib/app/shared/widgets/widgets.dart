import 'package:flutter/material.dart';
import 'package:uniprint/app/shared/temas/tema.dart';

class TextTitle extends StatelessWidget {
  final String title;

  const TextTitle(this.title);

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
  final String title;
  final bool isSelect;
  final GestureTapCallback onTap;

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

class ChipButtonState extends StatelessWidget {
  final String title;
  final bool isSelected;
  final GestureTapCallback onTap;

  const ChipButtonState(this.title, this.isSelected, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
            color: isSelected ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            border: new Border.all(
                color: isDarkMode(context) ? Colors.transparent : Colors.blue)),
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
