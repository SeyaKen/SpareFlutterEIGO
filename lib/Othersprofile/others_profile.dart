import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterstudeng/profile/answers.dart';
import 'package:flutterstudeng/profile/edit_profile.dart';
import 'package:flutterstudeng/profile/quesions.dart';
import 'package:flutterstudeng/services/auth.dart';
import 'package:flutterstudeng/services/database.dart';

class OthersProfile extends StatefulWidget {
  OthersProfile({Key? key, required this.othersUid}) : super(key: key);
  String othersUid;

  @override
  State<OthersProfile> createState() => _OthersProfileState(othersUid);
}

class _OthersProfileState extends State<OthersProfile> {
  String othersUid;
  Stream<QuerySnapshot<Object?>>? profileListsStream;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool switchColor0 = true;
  bool switchColor1 = false;

  _OthersProfileState(this.othersUid);

  getHomeLists() async {
    profileListsStream = await DatabaseService(othersUid).fetchImage();
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
                  key: _scaffoldKey,
                  appBar: AppBar(
              automaticallyImplyLeading: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(
                              context,
                            );
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  resizeToAvoidBottomInset: false,
                  body: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(150.0),
                              child: SizedBox(
                                width: 110,
                                height: 110,
                                child: Image.network(
                                  snapshot.data!.docs[0]['ProfilePicture'] == ''
                                      ? 'https://firebasestorage.googleapis.com/v0/b/studeng.appspot.com/o/44884218_345707102882519_2446069589734326272_n.jpeg?alt=media&token=aa902126-70a5-4511-a5ea-3e1d1eba2d53'
                                      : snapshot.data!.docs[0]
                                          ['ProfilePicture'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.05),
                            Expanded(
                              child: Text(
                                snapshot.data!.docs[0]['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Text(
                              snapshot.data!.docs[0]['selfIntroduction'],
                              style: const TextStyle(
                                fontSize: 19,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          Row(children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  switchColor0 = !switchColor0;
                                  switchColor1 = !switchColor1;
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: switchColor0
                                          ? Colors.black
                                          : Colors.grey,
                                      width: switchColor0 ? 2.0 : 1.0,
                                    ),
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: const Center(
                                  child: Text('質問',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      )),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  switchColor0 = !switchColor0;
                                  switchColor1 = !switchColor1;
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: switchColor1
                                          ? Colors.black
                                          : Colors.grey,
                                      width: switchColor1 ? 2.0 : 1.0,
                                    ),
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: const Center(
                                  child: Text('回答',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      )),
                                ),
                              ),
                            ),
                          ])
                        ],
                      ),
                      // ここに質問のリストを載せる
                      Flexible(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width,
                          child: switchColor0
                              ? Questions(othersUid)
                              : Answers(othersUid),
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator());
        });
  }
}
