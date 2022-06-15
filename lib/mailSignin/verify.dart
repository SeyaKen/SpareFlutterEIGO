import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterstudeng/main_page.dart';
import 'package:flutterstudeng/services/sharedpref_helper.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    user = auth.currentUser!;
    user.sendEmailVerification();

    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                  'noreply@studeng.firebaseapp.comから認証用のリンクを送りましたので、アクセスし登録を完了してください。',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 10),
              Text('※指定したリンクにアクセスした後このページに戻ると自動で登録が完了します。',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'ProfilePicture': '',
        'email': user.email,
        'name': '',
        'selfIntroduction': '',
        'uid': uid,
      });
      SharedPreferenceHelper().saveUserName('LogIned');
      Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => MainPage(
              currenttab: 0,
            ),
            transitionDuration: const Duration(seconds: 0),
          ));
    }
  }
}
