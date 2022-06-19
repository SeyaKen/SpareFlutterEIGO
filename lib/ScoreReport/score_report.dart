import 'package:flutter/material.dart';
import 'package:flutterstudeng/ScoreReport/toeic_report.dart';

class ScoreReport extends StatefulWidget {
  const ScoreReport({Key? key}) : super(key: key);

  @override
  State<ScoreReport> createState() => _ScoreReportState();
}

class _ScoreReportState extends State<ScoreReport> {
  int? score;
  List<Shadow> shado = [
    const Shadow(),
    const Shadow(color: Colors.transparent),
  ];

  final dataMap = <String, double>{
    "Score": 980,
  };

  final colorList = <Color>[
    const Color(0xff003082),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('スコア',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        crossAxisCount: 2,
        children: [
          InkWell(
            onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const ToeicScreen(),
                    transitionDuration: const Duration(seconds: 0),
                  ),
                );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.45,
              height: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xff003082),
                  width: 8,
                ),
                borderRadius: BorderRadius.circular(10000),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'TOEIC',
                    style: TextStyle(
                      color: Color(0xff003082),
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
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
