import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ToeicScreen extends StatefulWidget {
  const ToeicScreen({Key? key}) : super(key: key);

  @override
  State<ToeicScreen> createState() => _ToeicScreenState();
}

class _ToeicScreenState extends State<ToeicScreen> {
  final List<Color> gradientsColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LineChart(
        LineChartData(
          
        )
      ),
    );
  }
}
