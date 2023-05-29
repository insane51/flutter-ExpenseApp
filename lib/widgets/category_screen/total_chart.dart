import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/databaseProvider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class TotalChart extends StatefulWidget {
  const TotalChart({super.key});

  @override
  State<TotalChart> createState() => _TotalChartState();
}

class _TotalChartState extends State<TotalChart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (_, db, __) {
      var list = db.categories;
      var total = db.calculateTotalAmount();
      return Row(
        children: [
          Expanded(
              flex: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Total Expences : ${NumberFormat.currency(locale: 'en_IN', symbol: '₹ ').format(total)}',
                      textScaleFactor: 1.5,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  ...list.map((e) => Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Row(children: [
                          Container(
                            width: 8.0,
                            height: 8.0,
                            color: Colors.primaries[list.indexOf(e)],
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(e.title),
                          const SizedBox(width: 5.0),
                          Text(total == 0
                              ? '0%'
                              : '${((e.totalAmount / total) * 100).toStringAsFixed(2)}%')
                        ]),
                      ))
                ],
              )),
          Expanded(
              flex: 40,
              child: PieChart(PieChartData(
                  centerSpaceRadius: 20.0,
                  sections: total != 0
                      ? list
                          .map((e) => PieChartSectionData(
                                showTitle: false,
                                value: e.totalAmount,
                                color: Colors.primaries[list.indexOf(e)],
                              ))
                          .toList()
                      : list
                          .map((e) => PieChartSectionData(
                                showTitle: false,
                                color: Colors.primaries[list.indexOf(e)],
                              ))
                          .toList()))),
        ],
      );
    });
  }
}
