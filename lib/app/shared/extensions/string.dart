import 'package:intl/intl.dart';

extension ST on String {
  DateTime dateFromHasura(DateTime defaultDate) {
    try {
      return DateFormat('yyyy-MM-ddTHH:mm:ss').parse(this);
    } catch (e) {
      //print(e);
      return defaultDate ?? null;
    }
  }

  bool isNullOrEmpty() {
    return this == null || this.isEmpty;
  }

  double toDouble({double defaultValue}) {
    return double.tryParse(this.replaceAll(',', '.')) ?? defaultValue ?? 0.0;
  }

  int toInt({int defaultValue}) {
    return this
        .toDouble(defaultValue: defaultValue?.toDouble() ?? 0.0)
        .toInt(); //obrigatorio passar pra double antes
  }

  String addZeros(int quantidade) {
    var string = '';
    for (int i = 0; i < quantidade; i++) {
      string += "0";
    }
    return string + this;
  }

  String upperCaseFirst() {
    if (this != null) {
      if (this.length > 1) {
        return this.substring(0, 1).toUpperCase() +
            this.substring(1).toLowerCase();
      } else
        return this.toUpperCase();
    } else
      return this;
  }
}
