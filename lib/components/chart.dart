import 'package:fdispensa/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTrnsaction;

  Chart(this.recentTrnsaction);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(
      7,
      (index) {
        final weekDay = DateTime.now().subtract(
          Duration(days: index),
        );

        double totalSum = 0.0;

        for (var i = 0; i < recentTrnsaction.length; i++) {
          bool sameDay = recentTrnsaction[i].date.day == weekDay.day;
          bool sameMonth = recentTrnsaction[i].date.month == weekDay.month;
          bool sameYear = recentTrnsaction[i].date.year == weekDay.year;

          if (sameDay && sameMonth && sameYear) {
            totalSum += recentTrnsaction[i].value;
          }
        }

        return {
          'day': DateFormat.E().format(weekDay)[0],
          'value': totalSum,
        };
      },
    ).reversed.toList();
  }

  double get _weektotalValue {
    return groupedTransactions.fold(
      0.0,
      (sum, element) {
        return sum + element['value'];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((e) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: e['day'],
                value: e['value'],
                percentage: (e['value'] as double) / _weektotalValue >= 0
                    ? (e['value'] as double) / _weektotalValue
                    : 0,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
