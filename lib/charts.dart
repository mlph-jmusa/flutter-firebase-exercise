import 'package:firebase_exercise_1/cacheManager.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:bezier_chart/bezier_chart.dart';
import 'constants.dart';

_RecordsChartState? recordsChartState;

class RecordsChart extends StatefulWidget {
  const RecordsChart({Key? key, required this.records}) : super(key: key);
  final Iterable<Record> records;

  @override
  _RecordsChartState createState() {
    recordsChartState = _RecordsChartState();
    return recordsChartState!;
  }
}

class _RecordsChartState extends State<RecordsChart> {
  Iterable<Record> records = [];
  var mode = ChartMode.weekly;

  @override
  void initState() {
    records = widget.records;
    super.initState();
  }

  @override
  void dispose() {
    recordsChartState = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: CacheManager.getLaunchDate(),
        builder: (context, AsyncSnapshot<DateTime?> date) {
          if (date.connectionState == ConnectionState.waiting)
            return Container(child: Text('Loading'), alignment: Alignment.center);

          final fromDate =
              date.data ?? DateTime.now().subtract(Duration(days: 1));
          final toDate = DateTime.now();

          return Container(
            color: Colors.orangeAccent,
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  TextButton(
                      child: Text('Weekly'),
                      onPressed: () {
                        setState(() {
                          mode = ChartMode.weekly;
                        });
                      },
                      style: ButtonStyle(
                          fixedSize:
                              MaterialStateProperty.all<Size>(Size(90, 40)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              mode == ChartMode.weekly ? Colors.purpleAccent : Colors.grey.shade400),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white))),
                  Container(width: 10),
                  TextButton(
                      child: Text('Monthly'),
                      onPressed: () {
                        setState(() {
                          mode = ChartMode.monthly;
                        });
                      },
                      style: ButtonStyle(
                          fixedSize:
                              MaterialStateProperty.all<Size>(Size(90, 40)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              mode == ChartMode.monthly ? Colors.purpleAccent : Colors.grey.shade400),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white)))
                ]),
                Center(
                  child: Container(
                    height: (MediaQuery.of(context).size.height * 0.3),
                    width: MediaQuery.of(context).size.width,
                    child: BezierChart(
                      fromDate: fromDate,
                      bezierChartScale: mode == ChartMode.weekly
                          ? BezierChartScale.WEEKLY
                          : BezierChartScale.MONTHLY,
                      toDate: toDate,
                      selectedDate: toDate,
                      series: [
                        BezierLine(
                            data: records
                                .map((e) => DataPoint<DateTime>(
                                    value: e.type == RecordType.expense ? (e.amount * -1) : e.amount, xAxis: e.createdAt))
                                .toList()),
                      ],
                      config: BezierChartConfig(
                        verticalIndicatorStrokeWidth: 3.0,
                        verticalIndicatorColor: Colors.black26,
                        showVerticalIndicator: true,
                        verticalIndicatorFixedPosition: false,
                        // backgroundColor: Colors.orangeAccent,
                        footerHeight: 50.0,
                        displayDataPointWhenNoValue: false,
                        displayYAxis: true
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
