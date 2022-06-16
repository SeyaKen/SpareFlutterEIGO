import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterstudeng/main_page.dart';
import 'package:flutterstudeng/services/database.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key, required this.ex, required this.name})
      : super(key: key);
  String ex;
  String name;

  @override
  State<EditProfile> createState() => _EditProfileState(ex, name);
}

class _EditProfileState extends State<EditProfile> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  Stream<QuerySnapshot<Object?>>? profileListsStream;
  String ex, name;
  _EditProfileState(this.ex, this.name);
  final _formKey = GlobalKey<FormState>();
  final _exKey = GlobalKey<FormState>();

  getHomeLists() async {
    profileListsStream = await DatabaseService(uid).fetchImage();
    setState(() {});
  }

  onScreenLoaded() async {
    getHomeLists();
  }

  @override
  void initState() {
    onScreenLoaded();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: profileListsStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Scaffold(
                  appBar: AppBar(
                      iconTheme: const IconThemeData(
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      toolbarHeight: 60,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(width: 15),
                          InkWell(
                            onTap: () async {
                              DatabaseService(uid).updateUserName(name);
                              DatabaseService(uid).updateUserEx(ex);
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        MainPage(currenttab: 2),
                                    transitionDuration:
                                        const Duration(seconds: 0),
                                  ));
                            },
                            child: const Text(
                              '完了',
                              style: TextStyle(
                                color: Color(0xff0095f6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )),
                  resizeToAvoidBottomInset: false,
                  body: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(150.0),
                                  child: SizedBox(
                                    width: 110,
                                    height: 110,
                                    child: Image.network(
                                      snapshot.data!.docs[0]
                                                  ['ProfilePicture'] ==
                                              ''
                                          ? 'https://firebasestorage.googleapis.com/v0/b/studeng.appspot.com/o/44884218_345707102882519_2446069589734326272_n.jpeg?alt=media&token=aa902126-70a5-4511-a5ea-3e1d1eba2d53'
                                          : snapshot.data!.docs[0]
                                              ['ProfilePicture'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                                onPressed: () {
                                  DatabaseService(uid).updateImage();
                                },
                                child: const Text('プロフィール写真を変更',
                                    style: TextStyle(
                                      color: Color(0xff0095f6),
                                      fontWeight: FontWeight.bold,
                                    ))),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '名前',
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Form(
                                      key: _formKey,
                                      child: TextFormField(
                                        initialValue: name,
                                        onChanged: (val) {
                                          setState(() => name = val);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.80,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '自己紹介',
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: TextFormField(
                                      initialValue: ex,
                                      onChanged: (val) {
                                        setState(() => ex = val);
                                      },
                                      key: _exKey,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))
              : const Center(child: CircularProgressIndicator());
        });
  }
}
