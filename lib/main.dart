import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_exercise_1/constants.dart';
import 'package:flutter/material.dart';
import 'addRecord.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MoneyTracker());

class MoneyTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return MaterialApp(title: 'Money Tracker', home: Dashboard());
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(title: 'Money Tracker', home: Dashboard());
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(title: 'Money Tracker', home: Dashboard());
      },
    );
    // return MaterialApp(title: 'Money Tracker', home: Dashboard());
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

class ScrollableHomeContents extends StatelessWidget {
  const ScrollableHomeContents({Key? key}) : super(key: key);

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
                          .collection('testcollection')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) return const Text('Loading...');

                        return Container(
                            height: size.height * 0.3,
                            width: size.width,
                            color: Colors.red,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Total amount:',
                                  style: TextStyle(
                                      fontSize: 21, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.data?.docs.first["testvalue"]
                                          .toString() ??
                                      "WRONG",
                                  style: TextStyle(
                                      fontSize: 30, fontWeight: FontWeight.bold),
                                )
                              ],
                            ));
                      }),
                  Container(
                      height: size.height * 0.3,
                      width: size.width,
                      color: Colors.green,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Barrscharts',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                  Container(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('records').snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        
                        if (!snapshot.hasData) return const Text('Connection Error');
                        return ListView.separated(shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, position) {
                          var amount = snapshot.data?.docs[position]["amount"].toString() ?? '';
                          var desc = snapshot.data?.docs[position]["desc"].toString() ?? '';
                          var date = snapshot.data?.docs[position]["updatedAt"].toString() ?? '';
                        return RecordCell(amount: amount, desc: desc, date: date);
                      }, separatorBuilder: (context, position) {
                        return Text('-------------');
                      }, itemCount: snapshot.data?.docs.length ?? 0);
                      })
                    // ListView(
                    //   semanticChildCount: 1,
                    //   children: [RecordCell()],
                    //   shrinkWrap: true,
                    //   physics: NeverScrollableScrollPhysics(),
                      
                    // ),
                    // height: size.height * 0.9,
                    // width: size.width,
                    // color: Colors.blue,
                    // alignment: Alignment.center,
                    // child: Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       'Lats 5 transactions',
                    //       style: TextStyle(
                    //           fontSize: 30, fontWeight: FontWeight.bold),
                    //     )
                    //   ],
                    // )
                  ),
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
  const RecordCell({Key? key, required this.amount, required this.desc, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
      child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text('Amount:\n' + amount, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
            Text('Description:\n' + desc, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
            Text('Date:\n' + date, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
          ])),
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
                        builder: (context) =>
                            AddRecord(type: RecordType.expense)));
              },
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                      Size(size.width * 0.23, 50)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueAccent),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black)),
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
                        builder: (context) =>
                            AddRecord(type: RecordType.income)));
              },
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(Size(100, 50)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black)),
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
                        builder: (context) =>
                            AddRecord(type: RecordType.money)));
              },
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                      Size(size.width * 0.23, 50)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black)),
            )
          ],
        ),
      ),
    );
  }
}
