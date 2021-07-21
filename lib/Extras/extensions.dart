// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';

String formatDate(DateTime _date, { String format = "MMM dd yyyy"} ) {
  var formatter = DateFormat(format);
  return formatter.format(_date);
}

extension DateTimeExtension on DateTime {
  String toFormatterString() {
    return formatDate(this);
  }
}

extension DoubleExtension on double {
  String toCurrency() {
    final formatter = NumberFormat("₱#,##0.00", "en_US");
    return formatter.format(this);
  }
}

extension StringExtension on String {
  bool isNumeric() {
      return double.tryParse(this) != null;
    }
}
