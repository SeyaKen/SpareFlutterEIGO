import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterstudeng/SelectLogin/select_login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  final googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  

  Future signOut(context) async {
    await googleSignIn.disconnect();
    // ここでキーを外す
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear().then((value) => auth.signOut().then((value) => {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const SelectLoginScreen(),
          transitionDuration: const Duration(seconds: 0),
        ))
    }));
  }
}