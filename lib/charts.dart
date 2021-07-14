import 'package:firebase_exercise_1/cacheManager.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:bezier_chart/bezier_chart.dart';
import 'constants.dart';

class RecordsChart extends StatefulWidget {
  const RecordsChart({Key? key, required this.records}) : super(key: key);
  final Iterable<Record> records;
  // final Function reloadChart;

  @override
  _RecordsChartState createState() => _RecordsChartState();

}

class _RecordsChartState extends State<RecordsChart> {
  late Iterable<Record> records;
  // late Function reloadChart;

  @override
  void initState() {
    records = widget.records;
    super.initState();
  }

  void reload(Iterable<Record> records) {
    this.records = records;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) return Text('Loading...');

    return FutureBuilder(
        future: CacheManager.getLaunchDate(),
        builder: (context, AsyncSnapshot<DateTime?> date) {
          if (date.connectionState == ConnectionState.waiting)
            return Text('Loading');

          final fromDate =
              date.data ?? DateTime.now().subtract(Duration(days: 1));
          final toDate = DateTime.now();

          return Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              child: BezierChart(
                fromDate: fromDate,
                bezierChartScale: BezierChartScale.WEEKLY,
                toDate: toDate,
                selectedDate: toDate,
                series: [
                  BezierLine(
                      data: records
                          .map((e) => DataPoint<DateTime>(
                              value: e.amount, xAxis: e.createdAt))
                          .toList()),
                ],
                config: BezierChartConfig(
                  verticalIndicatorStrokeWidth: 3.0,
                  verticalIndicatorColor: Colors.black26,
                  showVerticalIndicator: true,
                  verticalIndicatorFixedPosition: false,
                  backgroundColor: Colors.orangeAccent,
                  footerHeight: 50.0,
                  displayDataPointWhenNoValue: false,
                  displayYAxis: true,
                ),
              ),
            ),
          );
        });
  }
}
