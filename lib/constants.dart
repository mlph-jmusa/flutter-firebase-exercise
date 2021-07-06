
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

extension RecorTypeExt on RecordType {
  String get stringValue {
    switch (this) {
      case RecordType.income: return 'Income';
      case RecordType.expense: return 'Expense';
      case RecordType.money: return 'Money on hand';
    }
  }
}