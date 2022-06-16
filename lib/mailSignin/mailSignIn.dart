import 'package:flutter/material.dart';
import 'package:flutterstudeng/SelectLogin/select_login_screen.dart';
import 'package:flutterstudeng/mailSignin/mailAuth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class mailSignIn extends StatefulWidget {
  final Function toggleView;
  const mailSignIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<mailSignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  dynamic error;
  bool eye = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const SelectLoginScreen(),
                      transitionDuration: const Duration(seconds: 0),
                    ),
                  );
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black,
                ),
              ),
              TextButton.icon(
                icon: const Icon(
                  Icons.person,
                ),
                label: const Text('新規登録画面へ'),
                onPressed: () async {
                  widget.toggleView();
                },
                style: TextButton.styleFrom(
                  primary: const Color(0xff0095f6),
                ),
              )
            ],
          ),
        ),
        body: GestureDetector(
          onTap: () {
            final FocusScopeNode currentScope = FocusScope.of(context);
            if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
          },
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.85,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'ログイン',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            validator: (val) =>
                                val!.isEmpty ? 'メールアドレスを入力してください' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              hintText: 'メールアドレス',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 13),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff0095f6),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Stack(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextFormField(
                                validator: (val) => val!.length < 7
                                    ? '7文字以上のパスワードを入力してください'
                                    : null,
                                obscureText: eye,
                                onChanged: (val) {
                                  setState(() => password = val);
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  hintText: 'パスワード',
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 13),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff0095f6),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 12,
                              right: 15,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    eye = !eye;
                                  });
                                },
                                child: Icon(
                                  eye
                                      ? FontAwesomeIcons.eyeSlash
                                      : FontAwesomeIcons.eye,
                                  size: 23,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Container(
                          decoration: BoxDecoration(
                            color: password.length >= 7
                                ? const Color(0xff0095f6)
                                : const Color(0xff0095f6).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 48,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    // ファイアベースでのメール認証の処理
                                    await _auth.signInWithEmailAndPassword(
                                        context,
                                        email.toString().trim(),
                                        password.toString().trim());
                                  }
                                },
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: const Center(
                                    child: Text(
                                      'ログイン',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: const Text('パスワードを忘れた場合'),
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            primary: const Color(0xff0095f6),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
