import 'package:firebase_core/firebase_core.dart';
import '/View/charts.dart';
import '/Extras/constants.dart';
import '/View/transactionHistory.dart';
import 'package:flutter/material.dart';
import 'View/addRecord.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/Extras/cacheManager.dart';
import '/Extras/extensions.dart';
import 'View/loading.dart';
import 'View/error.dart';
import '/View/Cell/recordCell.dart';
import '/Model/Record.dart';

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
              home: CustomError(errorMessage: "Error connecting to Firebase."));
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

                        remainingTotalMoneyOnHand =
                            ((totalMoneyOnHand + totalIncome) - totalExpenses);

                        return Container(
                            width: size.width,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10, left: 10, right: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.teal.shade200),
                                    height: size.height * 0.2,
                                    width: size.width,
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
                                            remainingTotalMoneyOnHand
                                                .toCurrency(),
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ]),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Expanded(
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.orangeAccent,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: RecordsChart(records: records)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Expanded(
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey.shade200),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                                            child: ListView.separated(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, position) {
                                                  Record record =
                                                      records.toList()[position];
                                                  return RecordCell(
                                                      amount: record.amount
                                                          .toCurrency(),
                                                      desc: record.desc,
                                                      date: record.createdAt
                                                          .toFormatterString(),
                                                      newTotalMoneyOnHand: record
                                                              .newTotalMoneyOnHand
                                                              ?.toCurrency() ??
                                                          "",
                                                      type: record.type);
                                                },
                                                separatorBuilder:
                                                    (context, position) {
                                                  return Padding(
                                                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.black),
                                                        height: 1),
                                                  );
                                                },
                                                itemCount: records.length < 5
                                                    ? records.length
                                                    : 5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                    child: TextButton(
                                        child: Text(records.isEmpty
                                            ? 'No Data'
                                            : 'View history'),
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
