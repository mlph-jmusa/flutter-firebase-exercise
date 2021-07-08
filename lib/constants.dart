
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
  final RecordType type;
  final double amount;
  final String desc;
  final DateTime createdAt;
  final DateTime updatedAt;

  Record(this.type, this.amount, this.desc, this.createdAt, this.updatedAt);
}