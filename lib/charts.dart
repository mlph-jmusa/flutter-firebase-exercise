import 'package:firebase_exercise_1/cacheManager.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:bezier_chart/bezier_chart.dart';
import 'constants.dart';

Widget sample3(BuildContext context, Iterable<Record> records) {
  return FutureBuilder(
      future: CacheManager.getLaunchDate(),
      builder: (context, AsyncSnapshot<DateTime?> date) {
        final fromDate = date.data ?? DateTime.now().subtract(Duration(days: 1));
        final toDate = DateTime.now();

        final date1 = DateTime.now().subtract(Duration(days: 2));
        final date2 = DateTime.now().subtract(Duration(days: 3));

        return Center(
          child: Container(
            color: Colors.red,
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            child: BezierChart(
              fromDate: fromDate,
              bezierChartScale: BezierChartScale.WEEKLY,
              toDate: toDate,
              selectedDate: toDate,
              series: [
                BezierLine(
                  label: "Duty",
                  onMissingValue: (dateTime) {
                    if (dateTime.day.isEven) {
                      return 10.0;
                    }
                    return 5.0;
                  },
                  data: [
                    DataPoint<DateTime>(value: 10, xAxis: date1),
                    DataPoint<DateTime>(value: 50, xAxis: date2),
                  ],
                ),
              ],
              config: BezierChartConfig(
                verticalIndicatorStrokeWidth: 3.0,
                verticalIndicatorColor: Colors.black26,
                showVerticalIndicator: true,
                verticalIndicatorFixedPosition: false,
                backgroundColor: Colors.red,
                footerHeight: 50.0,
                displayDataPointWhenNoValue: false
              ),
            ),
          ),
        );
      });
}
