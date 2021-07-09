
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';

enum TextFieldType {
  amount,
  description,
  date
}

extension TextFieldTypeExtension on TextFieldType {
  String get labelTextValue {
    switch (this) {
      case TextFieldType.amount: return 'Enter amount';
      case TextFieldType.description: return 'Enter description';
      case TextFieldType.date: return 'Enter date';
    }
  }
}

enum RecordType {
  expense,
  income,
  money
}

extension RecordTypeExt on RecordType {
  String get stringValue {
    switch (this) {
      case RecordType.income: return 'Income';
      case RecordType.expense: return 'Expense';
      case RecordType.money: return 'Money on hand';
    }
  }

  int get intValue {
    switch (this) {
      case RecordType.income: return 1;
      case RecordType.expense: return 0;
      case RecordType.money: return 2;
    }
  }
}

class RecordTypeHelper {
  static RecordType getType(int value) {
    switch (value) {
      case 0: return RecordType.expense;
      case 1: return RecordType.income;
      case 2: return RecordType.money;
      default: return RecordType.expense;
    }
  }
}

class Record {
  RecordType type;
  double amount;
  String desc;
  DateTime createdAt;

  Record(this.type, this.amount, this.desc, this.createdAt);
}

String formatDate(DateTime _date) {
    var formatter = DateFormat("MMMM dd, yyyy");
    return formatter.format(_date);
  }