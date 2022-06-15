import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterstudeng/HomeDetail/home_detail.dart';
import 'package:flutterstudeng/services/database.dart';

class Answers extends StatefulWidget {
  Answers(this.uid, {Key? key}) : super(key: key);
  String uid;

  @override
  State<Answers> createState() => _AnswersState(uid);
}

class _AnswersState extends State<Answers> {
  _AnswersState(this.uid);
  String uid;
  Stream<QuerySnapshot<Object?>>? questionsListsStream;

  getQuestinosLists() async {
    questionsListsStream = DatabaseService(uid).personalAnsersCollect();
    setState(() {});
  }

  @override
  void initState() {
    getQuestinosLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: questionsListsStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => HomeDetail(
                              articleId: snapshot.data!.docs[index].id,
                              askerId: snapshot.data!.docs[index]['asker'],
                              fromWhere: 'profile',
                            ),
                            transitionDuration: const Duration(seconds: 0),
                          ),
                        );
                      },
                      child: Container(
                        height: 140,
                        decoration: const BoxDecoration(
                            border: Border(
                          top: BorderSide(width: 0.5, color: Colors.grey),
                        )),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 15),
                        // color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text(
                                snapshot.data!.docs[index]['caption'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text(
                                snapshot.data!.docs[index]['questionList'][0],
                                style: const TextStyle(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(150.0),
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .where('uid',
                                              isEqualTo: snapshot
                                                  .data!.docs[index]['asker'])
                                          .snapshots(),
                                      builder: (context, snapshot0) {
                                        return snapshot0.hasData
                                            ? Image.network(
                                                snapshot0.data!.docs[0][
                                                            'ProfilePicture'] ==
                                                        ''
                                                    ? 'https://firebasestorage.googleapis.com/v0/b/studeng.appspot.com/o/44884218_345707102882519_2446069589734326272_n.jpeg?alt=media&token=aa902126-70a5-4511-a5ea-3e1d1eba2d53'
                                                    : snapshot0.data!.docs[0]
                                                        ['ProfilePicture'],
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                'https://firebasestorage.googleapis.com/v0/b/studeng.appspot.com/o/44884218_345707102882519_2446069589734326272_n.jpeg?alt=media&token=aa902126-70a5-4511-a5ea-3e1d1eba2d53',
                                                fit: BoxFit.cover,
                                              );
                                      }),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('users')
                                                .where('uid',
                                                    isEqualTo: snapshot.data!
                                                        .docs[index]['asker'])
                                                .snapshots(),
                                            builder: (context, snapshot1) {
                                              return snapshot1.hasData
                                                  ? Text(
                                                      snapshot1.data!.docs[0]
                                                          ['name'],
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                    )
                                                  : const Text('');
                                            }),
                                        const SizedBox(height: 5),
                                        Text(
                                          snapshot.data!.docs[index]['date']
                                              .toDate()
                                              .toString()
                                              .substring(0, 16),
                                          style: const TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                            ]),
                          ],
                        ),
                      ),
                    );
                  })
              : Container();
        });
  }
}
