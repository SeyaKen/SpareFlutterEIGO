import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterstudeng/Home/home_screen.dart';
import 'package:flutterstudeng/main_page.dart';
import 'package:flutterstudeng/services/auth.dart';
import 'package:flutterstudeng/services/sharedpref_helper.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // メールアドレスとパスワードでログイン
  Future signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) => {
                if (FirebaseAuth.instance.currentUser!.emailVerified) {
                  SharedPreferenceHelper().saveUserName('LogIned'),
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => MainPage(currenttab: 0),
                        transitionDuration: const Duration(seconds: 0),
                      ))
                  } else {
                    errorBox(context, 'メール認証が終わっていません。')
                  }
              });
    } catch (e) {
      print(e.toString());
      if (e.toString() ==
          '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.') {
        errorBox(context, 'パスワードが間違っています。');
      } else if (e.toString() ==
          '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.') {
        errorBox(context, '一致するユーザーが見つかりません。新規登録画面から登録してください。');
      }
    }
  }

  void errorBox(context, e) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("閉じる"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          title: const Text('エラー'),
          content: Text(e.toString()),
        );
      },
    );
  }
}
