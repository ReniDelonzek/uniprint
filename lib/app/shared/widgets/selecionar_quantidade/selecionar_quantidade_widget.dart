import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:uniprint/app/shared/utils/utils_cadastro.dart';
import 'package:uniprint/app/shared/extensions/string.dart';

import 'selecionar_quantidade_controller.dart';

class SelecionarQuantidadeWidget extends StatelessWidget {
  final SelecionarQuantidadeController controller;
  final double quantidade;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final bool alteravel;
  final bool inteiro;

  SelecionarQuantidadeWidget(this.quantidade, this.controller,
      {this.min = 1,
      this.max = 999999999999999,
      this.onChanged,
      this.alteravel,
      this.inteiro}) {
    controller.quantidade = this.quantidade;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (alteravel != false) {
            _showDialogQuantidade(context);
          } else {
            showSnack(context,
                'Você não pode alterar o número de páginas do documento');
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: Color(0xFFf5f5f5),
                  borderRadius: BorderRadius.circular(15)),
              child: InkWell(
                child: Icon(Icons.remove, size: 18),
                onTap: alteravel != false
                    ? () {
                        if (controller.quantidade > min) {
                          --controller.quantidade;
                          if (onChanged != null) {
                            onChanged(controller.quantidade);
                          }
                        }
                      }
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Observer(
                  builder: (_) => Text(
                        (inteiro == true
                                ? controller.quantidade.toInt()
                                : controller.quantidade)
                            .toString(),
                        style: TextStyle(fontSize: 15),
                      )),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: Color(0xFFf5f5f5),
                  borderRadius: BorderRadius.circular(15)),
              child: InkWell(
                child: Icon(Icons.add, size: 18),
                onTap: alteravel != false
                    ? () {
                        if (max > -1.0 && controller.quantidade < max) {
                          ++controller.quantidade;
                          if (onChanged != null) {
                            onChanged(controller.quantidade);
                          }
                        }
                      }
                    : null,
              ),
            ),
          ],
        ));
  }

  _showDialogQuantidade(BuildContext context) {
    controller.cltQuantidade.text = (inteiro == true
            ? controller.quantidade.toInt()
            : controller.quantidade)
        .toString();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Insira a quantidade'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: inteiro == false),
                    decoration:
                        InputDecoration(labelText: 'Quantidade de Toras'),
                    controller: controller.cltQuantidade,
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text('Confirmar'),
                    onPressed: () {
                      if (controller.cltQuantidade.text.isEmpty) {
                        showSnack(context, 'A quantidade não pode ficar vazia');
                      } else if (controller.cltQuantidade.text.toDouble() <
                          min) {
                        showSnack(context,
                            'A quantidade especificada é menor que a quantidade mínima permitida');
                      } else if (controller.cltQuantidade.text.toDouble() >
                          max) {
                        showSnack(context,
                            'A quantidade especificada é maior que a quantidade máxima permitida');
                      } else {
                        controller.quantidade =
                            controller.cltQuantidade.text.toDouble();
                        if (onChanged != null) {
                          onChanged(controller.quantidade);
                        }
                        Navigator.pop(context);
                      }
                    })
              ],
            ));
  }
}
