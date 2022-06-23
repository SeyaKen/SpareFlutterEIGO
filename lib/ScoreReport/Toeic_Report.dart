// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class ToeicScreen extends StatefulWidget {
//   const ToeicScreen({Key? key}) : super(key: key);

//   @override
//   State<ToeicScreen> createState() => _ToeicScreenState();
// }

// class _ToeicScreenState extends State<ToeicScreen> {
//   final List<Color> gradientColors = [
//     Colors.white,
//     Colors.white,
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LineChart(LineChartData(
//           minX: 0,
//           maxX: 11,
//           backgroundColor: const Color(0xff3800ff),
//           titlesData: LineTitles.getTittleData(),
//           gridData: FlGridData(
//             show: false,
//           ),
//           lineBarsData: [
//             LineChartBarData(
//               spots: [
//                 FlSpot(0, 700),
//                 FlSpot(2, 710),
//                 FlSpot(4, 720),
//                 FlSpot(6, 730),
//                 FlSpot(8, 790),
//                 FlSpot(9, 900),
//                 FlSpot(11, 990),
//               ],
//               colors: gradientColors,
//               barWidth: 5,
//             )
//           ])),
//     );
//   }
// }

// class LineTitles {
//   static getTittleData() => FlTitlesData(
//       show: true,
//       bottomTitles: SideTitles(
//         showTitles: true,
//         reservedSize: 22,
//         getTextStyles: (value) => const TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//           fontSize: 16, 
//         ),
//         getTitles: (value) {
//           switch (value.toInt()) {
//             case 2:
//               return 'MAR';
//             case 5:
//               return 'JUN';
//             case 8:
//               return 'SEP';
//           }
//           return '';
//         },
//         margin: 8,
//       ));
// }
