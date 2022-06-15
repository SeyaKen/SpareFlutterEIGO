import 'package:flutter/material.dart';
import 'package:flutterstudeng/mailSignin/mailRegister.dart';
import 'package:flutterstudeng/mailSignin/mailSignIn.dart';

class mailAuthenticate extends StatefulWidget {
  const mailAuthenticate({Key? key}) : super(key: key);

  @override
  _mailAuthenticateState createState() => _mailAuthenticateState();
}

class _mailAuthenticateState extends State<mailAuthenticate> {
  bool showSignIn = false;
  void toggleView() {
    //print(showSignIn.toString());
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return mailRegister(toggleView);
    } else {
      return mailSignIn(toggleView);
    }
  }
}