
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