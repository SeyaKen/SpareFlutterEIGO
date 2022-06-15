import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterstudeng/SelectLogin/select_login_screen.dart';
import 'package:flutterstudeng/main_page.dart';
import 'package:flutterstudeng/services/sharedpref_helper.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  Future<void> starttimer() async {
    loginCheck = await SharedPreferenceHelper().getUserName();
    Timer(const Duration(seconds: 1), () async {
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => 
          loginCheck == null 
          ? const SelectLoginScreen()
          : MainPage(currenttab: 0,)));
    });
  }

  String? loginCheck;

  @override
  void initState() {
    super.initState();
    starttimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
            color: Colors.white,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.8,
                    child: Image.asset('assets/icon.png')),
              ],
            ))));
  }
}
