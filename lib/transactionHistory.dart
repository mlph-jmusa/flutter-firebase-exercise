import 'package:flutter/material.dart';
import 'constants.dart';
import 'main.dart';
import 'extensions.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key, required this.records}) : super(key: key);
  final Iterable<Record> records;

  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  late Iterable<Record> records;

  @override
  void initState() {
    records = widget.records;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transaction history')),
      body: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: ListView.separated(
                itemBuilder: (context, position) {
                  Record record = records.toList()[position];
                  return RecordCell(
                      amount: record.amount.toString(),
                      desc: record.desc,
                      date: record.createdAt.toFormatterString(),
                      type: record.type, newTotalMoneyOnHand: record.newTotalMoneyOnHand?.toCurrency() ?? "",);
                },
                separatorBuilder: (context, position) {
                  return Container(decoration: BoxDecoration(color: Colors.black), height: 1);
                },
                itemCount: records.length),
          )),
    );
  }
}
