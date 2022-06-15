import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterstudeng/Answer/answer_screen.dart';
import 'package:flutterstudeng/EditAnswer/edit_answer.dart';
import 'package:flutterstudeng/HomeDetail/picture_detail.dart';
import 'package:flutterstudeng/Othersprofile/others_profile.dart';
import 'package:flutterstudeng/main_page.dart';

class HomeDetail extends StatefulWidget {
  HomeDetail({Key? key, required this.articleId, required this.askerId, required this.fromWhere})
      : super(key: key);
  String articleId, askerId, fromWhere;

  @override
  State<HomeDetail> createState() => _HomeDetailState(articleId, askerId, fromWhere);
}

late List AnswerLists;

class _HomeDetailState extends State<HomeDetail> {
  String articleId, askerId, fromWhere;
  int? counT;
  DocumentSnapshot? firebasesnapshot;
  int buttonCheck = -1;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  _HomeDetailState(this.articleId, this.askerId, this.fromWhere);

  Future InAdvance() async {
    firebasesnapshot = await FirebaseFirestore.instance
        .collection('questions')
        .doc(articleId)
        .get();

    counT = firebasesnapshot!.get('questionList').length;

    AnswerLists = firebasesnapshot!.get('answersList');

    setState(() {});
  }

  @override
  void initState() {
    InAdvance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return firebasesnapshot != null
        ? Scaffold(
            backgroundColor: const Color(0xfffafafa),
            appBar: AppBar(
              shape: const Border(
                  bottom: BorderSide(color: Color(0xffdbdbdb), width: 1)),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
              title: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  MainPage(currenttab: fromWhere == 'home' ? 0 : 2),
                              transitionDuration: const Duration(seconds: 0),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(firebasesnapshot!.get('caption'),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ),
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
            ),
            body: InkWell(
              onTap: () {
                setState(() {
                  buttonCheck = -1;
                });
              },
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('questions')
                                    .doc(articleId)
                                    .collection('answers')
                                    .snapshots(),
                                builder: (context, snap) {
                                  return snap.hasData && counT != null
                                      ? ListView.builder(
                                          // snap.data!.docs.length=anwersの長さ
                                          // countT = questionListのlength
                                          itemCount: snap.data!.docs.length +
                                              counT! +
                                              2,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return index > counT! + 1
                                                ? Stack(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal:
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.05),
                                                        margin: const EdgeInsets
                                                            .only(top: 20),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration:
                                                            const BoxDecoration(
                                                                color: Colors
                                                                    .white),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 20),
                                                          child: StreamBuilder<
                                                                  QuerySnapshot>(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .where('uid',
                                                                      isEqualTo: snap.data!.docs[index -
                                                                              counT! -
                                                                              2]
                                                                          [
                                                                          'answer'])
                                                                  .snapshots(),
                                                              builder: (context,
                                                                  snap7) {
                                                                return snap7
                                                                        .hasData
                                                                    ? Column(
                                                                        children: [
                                                                          index == counT! + 2
                                                                              ? Padding(
                                                                                  padding: const EdgeInsets.only(bottom: 20),
                                                                                  child: Row(
                                                                                    children: const [
                                                                                      SizedBox(width: 3),
                                                                                      Text(
                                                                                        '回答',
                                                                                        style: TextStyle(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          fontSize: 20,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              : Container(),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  Navigator.push(
                                                                                      context,
                                                                                      PageRouteBuilder(
                                                                                        pageBuilder: (_, __, ___) => OthersProfile(othersUid: snap.data!.docs[index - counT! - 2]['answer']),
                                                                                        transitionDuration: const Duration(seconds: 0),
                                                                                      ));
                                                                                },
                                                                                child: Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(150.0),
                                                                                      child: SizedBox(
                                                                                        width: 50,
                                                                                        height: 50,
                                                                                        child: Image.network(
                                                                                          snap7.data!.docs[0]['ProfilePicture'],
                                                                                          fit: BoxFit.cover,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(width: 10),
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        const SizedBox(height: 5),
                                                                                        Text(
                                                                                          snap7.hasData ? snap7.data!.docs[0]['name'] : '',
                                                                                          style: const TextStyle(
                                                                                            fontSize: 12,
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(height: 5),
                                                                                        Text(snap.data!.docs[index - counT! - 2]['date'].toDate().toString().substring(0, 16))
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              uid == snap.data!.docs[index - counT! - 2].id
                                                                                  ? InkWell(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          if (buttonCheck == -1) {
                                                                                            buttonCheck = index;
                                                                                          } else if (buttonCheck != -1 && buttonCheck == index) {
                                                                                            buttonCheck = -1;
                                                                                          } else {
                                                                                            buttonCheck = index;
                                                                                          }
                                                                                        });
                                                                                      },
                                                                                      child: const Icon(
                                                                                        Icons.more_horiz,
                                                                                        size: 38,
                                                                                      )
                                                                                    )
                                                                                  : Container(),
                                                                            ],
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(top: 10, bottom: index == snap.data!.docs.length + counT! + 1 ? 100 : 0),
                                                                            child: ListView.builder(
                                                                                physics: const NeverScrollableScrollPhysics(),
                                                                                shrinkWrap: true,
                                                                                itemCount: snap.data!.docs[index - counT! - 2]['answerList'].length,
                                                                                itemBuilder: (BuildContext context, int indexx) {
                                                                                  return snap.data!.docs[index - counT! - 2]['answerList'][indexx].length > 30
                                                                                      ? snap.data!.docs[index - counT! - 2]['answerList'][indexx].substring(0, 30) != 'https://firebasestorage.google'
                                                                                          ? Padding(
                                                                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                                              child: Text(snap.data!.docs[index - counT! - 2]['answerList'][indexx]),
                                                                                            )
                                                                                          : Padding(
                                                                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                                              child: InkWell(
                                                                                                onTap: () {
                                                                                                  Navigator.push(
                                                                                                    context,
                                                                                                    PageRouteBuilder(
                                                                                                      pageBuilder: (_, __, ___) => PictureDetail(pictureURL: snap.data!.docs[index - counT! - 2]['answerList'][indexx]),
                                                                                                      transitionDuration: const Duration(seconds: 0),
                                                                                                    ),
                                                                                                  );
                                                                                                },
                                                                                                child: Image.network(
                                                                                                  snap.data!.docs[index - counT! - 2]['answerList'][indexx],
                                                                                                  fit: BoxFit.cover,
                                                                                                ),
                                                                                              ),
                                                                                            )
                                                                                      : Padding(
                                                                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                                          child: Text(snap.data!.docs[index - counT! - 2]['answerList'][indexx]),
                                                                                        );
                                                                                }),
                                                                          )
                                                                        ],
                                                                      )
                                                                    : const Center(
                                                                        child:
                                                                            CircularProgressIndicator());
                                                              }),
                                                        ),
                                                      ),
                                                      buttonCheck == index
                                                          ? Positioned(
                                                              top: 90,
                                                              right: 60,
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius: const BorderRadius
                                                                          .only(
                                                                      topLeft:
                                                                          Radius.circular(
                                                                              10),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              10),
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              10),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              10)),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.5),
                                                                      spreadRadius:
                                                                          5,
                                                                      blurRadius:
                                                                          7,
                                                                      offset: const Offset(
                                                                          0,
                                                                          3), // changes position of shadow
                                                                    ),
                                                                  ],
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            PageRouteBuilder(
                                                                              pageBuilder: (_, __, ___) => EditAnswer(answerId: snap.data!.docs[index - counT! - 2].id, articleId: articleId, askerId: askerId),
                                                                              transitionDuration: const Duration(seconds: 0),
                                                                            ));
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                20,
                                                                            vertical:
                                                                                10),
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          border:
                                                                              Border(
                                                                            bottom:
                                                                                BorderSide(
                                                                              color: Colors.grey,
                                                                              width: 0.5,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          children: const [
                                                                            Text('編集する',
                                                                                style: TextStyle(
                                                                                  fontSize: 17,
                                                                                )),
                                                                            SizedBox(width: 10),
                                                                            Icon(
                                                                              Icons.edit,
                                                                              size: 25,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        //ここでanswersListからuidを消す
                                                                        AnswerLists.remove(
                                                                            uid);
                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection('questions')
                                                                            .doc(articleId)
                                                                            .update({
                                                                              'answersList': AnswerLists,
                                                                            });
                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection('questions')
                                                                            .doc(articleId)
                                                                            .collection('answers')
                                                                            .doc(uid)
                                                                            .delete();
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                20,
                                                                            vertical:
                                                                                10),
                                                                        child:
                                                                            Row(
                                                                          children: const [
                                                                            Text(
                                                                              '削除する',
                                                                              style: TextStyle(
                                                                                fontSize: 17,
                                                                                color: Colors.red,
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: 10),
                                                                            Icon(
                                                                              Icons.delete,
                                                                              size: 25,
                                                                              color: Colors.red,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                    ],
                                                  )
                                                : index == 0
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.symmetric(
                                                                vertical: 20,
                                                                horizontal: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.05),
                                                            decoration:
                                                                const BoxDecoration(
                                                                    color: Colors
                                                                        .white),
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Text(
                                                              firebasesnapshot!
                                                                  .get(
                                                                      'caption'),
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 25,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : index == 1
                                                        ? InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  PageRouteBuilder(
                                                                    pageBuilder: (_,
                                                                            __,
                                                                            ___) =>
                                                                        OthersProfile(
                                                                            othersUid:
                                                                                askerId),
                                                                    transitionDuration:
                                                                        const Duration(
                                                                            seconds:
                                                                                0),
                                                                  ));
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.only(
                                                                  right: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.05,
                                                                  left: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.05,
                                                                  bottom: 10),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                      color: Colors
                                                                          .white),
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              child: Row(
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              150.0),
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            30,
                                                                        height:
                                                                            30,
                                                                        child: StreamBuilder<
                                                                                QuerySnapshot>(
                                                                            stream:
                                                                                FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: askerId).snapshots(),
                                                                            builder: (context, snapshot0) {
                                                                              return snapshot0.hasData
                                                                                  ? Image.network(
                                                                                      snapshot0.data!.docs[0]['ProfilePicture'] == '' ? 'https://firebasestorage.googleapis.com/v0/b/studeng.appspot.com/o/44884218_345707102882519_2446069589734326272_n.jpeg?alt=media&token=aa902126-70a5-4511-a5ea-3e1d1eba2d53' : snapshot0.data!.docs[0]['ProfilePicture'],
                                                                                      fit: BoxFit.cover,
                                                                                    )
                                                                                  : Image.network(
                                                                                      'https://firebasestorage.googleapis.com/v0/b/studeng.appspot.com/o/44884218_345707102882519_2446069589734326272_n.jpeg?alt=media&token=aa902126-70a5-4511-a5ea-3e1d1eba2d53',
                                                                                      fit: BoxFit.cover,
                                                                                    );
                                                                            }),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            10),
                                                                    Column(
                                                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        StreamBuilder<
                                                                                QuerySnapshot>(
                                                                            stream:
                                                                                FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: askerId).snapshots(),
                                                                            builder: (context, snapshot1) {
                                                                              return Text(
                                                                                snapshot1.hasData ? snapshot1.data!.docs[0]['name'] : '',
                                                                                style: const TextStyle(
                                                                                  fontSize: 12,
                                                                                ),
                                                                              );
                                                                            }),
                                                                        const SizedBox(
                                                                            height:
                                                                                5),
                                                                        Text(
                                                                          firebasesnapshot!
                                                                              .get('date')
                                                                              .toDate()
                                                                              .toString()
                                                                              .substring(0, 16),
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ]),
                                                            ),
                                                          )
                                                        : firebasesnapshot!
                                                                    .get('questionList')[
                                                                        index -
                                                                            2]
                                                                    .length >
                                                                30
                                                            ? firebasesnapshot!
                                                                        .get('questionList')[
                                                                            index -
                                                                                2]
                                                                        .substring(
                                                                            0,
                                                                            30) !=
                                                                    'https://firebasestorage.google'
                                                                ? Container(
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                            color:
                                                                                Colors.white),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            8.0,
                                                                        horizontal:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.05),
                                                                    child: Text(
                                                                        firebasesnapshot!
                                                                            .get(
                                                                                'questionList')[index -
                                                                            2]),
                                                                  )
                                                                : Container(
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                            color:
                                                                                Colors.white),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            8.0,
                                                                        horizontal:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.05),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          PageRouteBuilder(
                                                                            pageBuilder: (_, __, ___) =>
                                                                                PictureDetail(pictureURL: firebasesnapshot!.get('questionList')[index - 2]),
                                                                            transitionDuration:
                                                                                const Duration(seconds: 0),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: Image
                                                                          .network(
                                                                        firebasesnapshot!
                                                                            .get(
                                                                                'questionList')[index -
                                                                            2],
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  )
                                                            : Container(
                                                                decoration: const BoxDecoration(
                                                                    color: Colors
                                                                        .white),
                                                                padding: EdgeInsets.symmetric(
                                                                    vertical:
                                                                        8.0,
                                                                    horizontal: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.05),
                                                                child: Text(
                                                                    firebasesnapshot!
                                                                            .get('questionList')[
                                                                        index -
                                                                            2]),
                                                              );
                                          })
                                      : const Center(
                                          child: CircularProgressIndicator());
                                }),
                          )
                        ],
                      ),
                    ),
                  ]),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        AnswerScreen(articleId: articleId, askerId: askerId),
                    transitionDuration: const Duration(seconds: 0),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xff3B00FF),
                  // border: Border.all(
                  //   color: Colors.black,
                  //   width: 4,
                  // ),
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                child: const Center(
                  child: Text('回答する',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      )),
                ),
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
