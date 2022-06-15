import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterstudeng/Home/home_screen.dart';
import 'package:flutterstudeng/ScoreReport/score_report.dart';
import 'package:flutterstudeng/profile/profile_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key, required this.currenttab}) : super(key: key);

  int currenttab;

  @override
  _MainPageState createState() => _MainPageState(currenttab);
}

class _MainPageState extends State<MainPage> {
  int currenttab;
  _MainPageState(this.currenttab);
  String? myUserUid;

  getMyUserUid() async {
    myUserUid = FirebaseAuth.instance.currentUser!.uid;
    setState(() {});
  }

  onScreenLoaded() async {
    await getMyUserUid();
    setState(() {});
  }

  @override
  void initState() {
    onScreenLoaded();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currenttab = index;
          });
        },
        currentIndex: currenttab,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xff00376b),
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.show_chart ,
              size: 30,
            ),
            label: 'スコアレポート',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 30,
            ),
            label: 'プロフィール',
          ),
        ]),
      body: IndexedStack(
        children: [
          const HomeScreen(),
          ScoreReport(),
          const ProfilePage(),
        ],
        index: currenttab,
      ),
    );
  }
}
