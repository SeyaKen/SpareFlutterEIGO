import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ToeicScreen extends StatefulWidget {
  const ToeicScreen({Key? key}) : super(key: key);

  @override
  State<ToeicScreen> createState() => _ToeicScreenState();
}

class _ToeicScreenState extends State<ToeicScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LineChart(
        LineChartData(
          minX: 0,
          maxX: 11,
          backgroundColor: const Color(0xff3800ff),
          titlesData: LineTitles.getTitleData(),
          gridData: FlGridData(
              show: false,
              ),
          lineBarsData: [
            LineChartBarData(spots: [
              const FlSpot(0, 700),
              const FlSpot(2, 710),
              const FlSpot(4, 720),
              const FlSpot(6, 730),
              const FlSpot(8, 790),
              const FlSpot(9, 900),
              const FlSpot(11, 990),
            ],
            color: Colors.white,
            barWidth: 5,
            )
          ])),
    );
  }
}

class LineTitles {
  static getTittleData() => FlTitlesData(
    show: true,
    bottomTitles: SideTitles(
      showTitles: true,
      getTitlesWidget: (value) {
        
      },
      margin: 8,
    )
  );
}
