import '/Extras/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  RecordType type;
  double amount;
  String desc;
  double? newTotalMoneyOnHand;
  double? oldTotalMoneyOnHand;
  DateTime createdAt;

  Record(this.type, this.amount, this.desc, this.createdAt);

  static Record init(QueryDocumentSnapshot<Object?> data) {
    RecordType type = RecordTypeHelper.getType(data["type"]);
    double amount = double.tryParse(data["amount"].toString()) ?? 0.0;
    String desc = data["desc"].toString();
    Timestamp _date = data["createdAt"];
    DateTime date = _date.toDate();
    double newTotalMoneyOnHand = double.tryParse(data["newTotalMoneyOnHand"].toString()) ?? 0.0;
    double oldTotalMoneyOnHand = double.tryParse(data["oldTotalMoneyOnHand"].toString()) ?? 0.0;
    var record = Record(type, amount, desc, date);
    record.newTotalMoneyOnHand = newTotalMoneyOnHand;
    record.oldTotalMoneyOnHand = oldTotalMoneyOnHand;
    
    return record;
  }
}