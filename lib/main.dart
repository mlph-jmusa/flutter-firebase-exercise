import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_exercise_1/charts.dart';
import 'package:firebase_exercise_1/constants.dart';
import 'package:firebase_exercise_1/transactionHistory.dart';
import 'package:flutter/material.dart';
import 'addRecord.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cacheManager.dart';
import 'extensions.dart';
import 'loading.dart';
import 'error.dart';

void main() => runApp(MoneyTracker());
double remainingTotalMoneyOnHand = 0.0;

class MoneyTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void setLaunchDate() {
      CacheManager.getLaunchDate().then((date) {
        if (date == null) {
          CacheManager.setLaunchDate(DateTime.now());
        }
      });
    }

    setLaunchDate();

    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return MaterialApp(
              title: 'Money Tracker',
              home:  CustomError(errorMessage: "Error connecting to Firebase."));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(title: 'Money Tracker', home: Dashboard());
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(title: 'Money Tracker', home: Loading());
      },
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Money Tracker'), backgroundColor: Colors.blueGrey),
      body: Stack(children: [ScrollableHomeContents(), DashboardButtons()]),
    );
  }
}

class ScrollableHomeContents extends StatefulWidget {
  const ScrollableHomeContents({Key? key}) : super(key: key);

  @override
  _ScrollableHomeContentsState createState() => _ScrollableHomeContentsState();
}

class _ScrollableHomeContentsState extends State<ScrollableHomeContents> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: Column(
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('records')
                          .orderBy("createdAt", descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData && snapshot.hasError)
                          return const Text('Error connecting to server');
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return const Text('Loading...');

                        var records =
                            snapshot.data?.docs.map((e) => Record.init(e)) ??
                                [];
                        if (recordsChartState != null) {
                          recordsChartState?.setState(() {
                            recordsChartState?.records = records;
                          });
                        }

                        var moneyOnHandRecords = records.where(
                            (element) => element.type == RecordType.money);
                        double totalMoneyOnHand = moneyOnHandRecords.fold(
                            0.0,
                            (previousValue, element) =>
                                previousValue + element.amount);
                        var expenseRecords = records.where(
                            (element) => element.type == RecordType.expense);
                        double totalExpenses = expenseRecords.fold(
                            0.0,
                            (previousValue, element) =>
                                previousValue + element.amount);
                        var incomeRecords = records.where(
                            (element) => element.type == RecordType.income);
                        double totalIncome = incomeRecords.fold(
                            0.0,
                            (previousValue, element) =>
                                previousValue + element.amount);

                        remainingTotalMoneyOnHand = ((totalMoneyOnHand + totalIncome) -
                                                  totalExpenses);

                        return Container(
                            // height: size.height * 0.2,
                            width: size.width,
                            // color: Colors.green,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: size.height * 0.2,
                                  width: size.width,
                                  color: Colors.teal.shade200,
                                  alignment: Alignment.center,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Money on hand:',
                                          style: TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          remainingTotalMoneyOnHand.toCurrency(),
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ]),
                                ),
                                Container(
                                    height: 20, color: Colors.orangeAccent),
                                Container(
                                  height: (size.height * 0.3) + 48,
                                    child: RecordsChart(records: records)),
                                Container(height: 20),
                                Column(
                                  children: [
                                    Container(
                                      child: ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, position) {
                                            Record record =
                                                records.toList()[position];
                                            return RecordCell(
                                                amount:
                                                    record.amount.toCurrency(),
                                                desc: record.desc,
                                                date: record.createdAt
                                                    .toFormatterString(),
                                                    newTotalMoneyOnHand: record.newTotalMoneyOnHand?.toCurrency() ?? "",
                                                type: record.type);
                                          },
                                          separatorBuilder:
                                              (context, position) {
                                            return Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black),
                                                height: 1);
                                          },
                                          itemCount: records.length < 5
                                              ? records.length
                                              : 5),
                                    ),
                                  ],
                                ),
                                Container(
                                    child: TextButton(
                                        child: Text(records.isEmpty ? 'No Data' :'View history'),
                                        onPressed: () {
                                          if (records.isEmpty) return;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TransactionHistory(
                                                          records: records)));
                                        })),
                              ],
                            ));
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
              width: size.width * 0.45,
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
                      child: Text(
                          newTotalMoneyOnHand,
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

class DashboardButtons extends StatelessWidget {
  const DashboardButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
              child: Text('Add\nExpenses',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddRecord(
                            record: Record(
                                RecordType.expense, 0.0, "", DateTime.now()))));
              },
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                      Size(size.width * 0.23, 50)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.indigo.shade500)),
            ),
            Container(
              width: size.width * 0.07,
            ),
            TextButton(
              child: Text('Add\nIncome',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddRecord(
                            record: Record(
                                RecordType.income, 0.0, "", DateTime.now()))));
              },
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(Size(100, 50)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.indigo.shade500)),
            ),
            Container(
              width: size.width * 0.07,
            ),
            TextButton(
              child: Text('Add\nMoney',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddRecord(
                            record: Record(
                                RecordType.money, 0.0, "", DateTime.now()))));
              },
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                      Size(size.width * 0.23, 50)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.indigo.shade500)),
            )
          ],
        ),
      ),
    );
  }
}
