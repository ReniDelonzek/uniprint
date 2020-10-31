import 'package:flutter/material.dart';
import 'package:uniprint/app/shared/widgets/widgets.dart';

class SelectWidget extends StatelessWidget {
  final String title;
  final String value;
  final GestureTapCallback onTap;

  SelectWidget(this.title, this.value, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          padding: EdgeInsets.only(bottom: 10, top: 5, left: 5),
          alignment: Alignment.centerLeft,
          child: TextTitle(title)),
      InkWell(
          onTap: onTap,
          child: Container(
              child: Container(
            height: 45,
            constraints: BoxConstraints(
                minWidth: 45, maxWidth: 500, minHeight: 45, maxHeight: 60),
            decoration: BoxDecoration(
                color: Color(0xFFf5f5f5),
                borderRadius: BorderRadius.circular(20)),
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              alignment: Alignment.centerLeft,
              child: Text(
                value ?? 'Clique para selecionar',
                maxLines: 2,
              ),
            ),
          )))
    ]);
  }
}
