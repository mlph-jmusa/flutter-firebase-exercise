// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
import 'constants.dart';

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

