import 'package:firebase_exercise_1/constants.dart';
import 'package:flutter/material.dart';

class RecordCell extends StatelessWidget {
  final String amount;
  final String desc;
  final String date;
  final String newTotalMoneyOnHand;
  final RecordType type;

  const RecordCell(
      {Key? key,
      required this.amount,
      required this.desc,
      required this.date,
      required this.newTotalMoneyOnHand,
      required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: Icon(type == RecordType.expense
                    ? Icons.arrow_circle_down
                    : Icons.arrow_circle_up),
                width: 60,
                height: 60,
                color: type == RecordType.expense
                    ? Colors.redAccent
                    : Colors.greenAccent),
            Container(
              width: size.width * 0.4,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(desc,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(type.stringValue,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.grey))),
                ]),
              ),
            ),
            Container(
              width: size.width * 0.35,
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: Text(
                          (type == RecordType.expense ? '-' : '+') + amount,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: type == RecordType.expense
                                  ? Colors.red
                                  : Colors.green))),
                  Align(
                      alignment: Alignment.topRight,
                      child: Text(newTotalMoneyOnHand,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.grey.shade500))),
                  Align(
                      alignment: Alignment.topRight,
                      child: Text(date,
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.grey, fontSize: 12))),
                ],
              ),
            )
          ],
        ));
  }
}