import 'package:intl/intl.dart';

extension ST on String {
  DateTime dateFromHasura(DateTime defaultDate) {
    try {
      return DateFormat('yyyy-MM-ddTHH:mm:ss').parse(this);
    } catch (e) {
      print(e);
      return defaultDate ?? null;
    }
  }

  bool isNullOrEmpty() {
    return this == null || this.isEmpty;
  }
}
