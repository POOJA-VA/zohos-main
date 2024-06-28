import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zohomain/src/presentation/barGraph/barData.dart';

class BarGraph extends StatelessWidget {
  final List weeklySummary;

  const BarGraph({super.key, required this.weeklySummary});

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      sunAmount: weeklySummary[0],
      monAmount: weeklySummary[1],
      tueAmount: weeklySummary[2],
      wedAmount: weeklySummary[3],
      thuAmount: weeklySummary[4],
      friAmount: weeklySummary[5],
      satAmount: weeklySummary[6],
    );
    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: 24,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => getBottomTitles(context, value),
            ),
          ),
        ),
        barGroups: myBarData.barData
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                    toY: data.y,
                    color: Color.fromARGB(218, 71, 167, 163),
                    width: 25,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 24,
                      color: Color.fromARGB(255, 221, 217, 217),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget getBottomTitles(BuildContext context, double value) {
    final style = TextStyle(
      color: Color.fromARGB(218, 71, 167, 163),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    switch (value.toInt()) {
      case 0:
        return Text(AppLocalizations.of(context)!.monday, style: style);
      case 1:
        return Text(AppLocalizations.of(context)!.tuesday, style: style);
      case 2:
        return Text(AppLocalizations.of(context)!.wednesday, style: style);
      case 3:
        return Text(AppLocalizations.of(context)!.thurday, style: style);
      case 4:
        return Text(AppLocalizations.of(context)!.friday, style: style);
      case 5:
        return Text(AppLocalizations.of(context)!.saturday, style: style);
      case 6:
        return Text(AppLocalizations.of(context)!.sunday, style: style);
      default:
        return Text('', style: style);
    }
  }
}