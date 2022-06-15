import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterstudeng/HomeDetail/home_detail.dart';
import 'package:flutterstudeng/services/database.dart';

class EditAnswer extends StatefulWidget {
  EditAnswer(
      {Key? key,
      required this.answerId,
      required this.articleId,
      required this.askerId})
      : super(key: key);
  String answerId, articleId, askerId;

  @override
  State<EditAnswer> createState() =>
      _AnswerScreenState(answerId, articleId, askerId);
}

List passages = [];
List deletePictures = [];

class _AnswerScreenState extends State<EditAnswer> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String answerId, articleId, askerId;
  int? counT;
  DocumentSnapshot? firebasesnapshot;
  _AnswerScreenState(this.answerId, this.articleId, this.askerId);

  Future InAdvance() async {
    firebasesnapshot = await FirebaseFirestore.instance
        .collection('questions')
        .doc(articleId)
        .collection('answers')
        .doc(answerId)
        .get();

    counT = firebasesnapshot!.get('answerList').length;

    for (var i = 0; i < counT!; i++) {
      passages.add(firebasesnapshot!.get('answerList')[i]);
    }

    setState(() {});
  }

  @override
  void initState() {
    InAdvance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
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
                          pageBuilder: (_, __, ___) => HomeDetail(
                            articleId: articleId,
                            askerId: askerId,
                            fromWhere: 'home',
                          ),
                          transitionDuration: const Duration(seconds: 0),
                        ),
                      );
                      passages = [];
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      FirebaseFirestore.instance
                          .collection('questions')
                          .doc(articleId)
                          .collection('answers')
                          .doc(uid)
                          .update({
                        'date': DateTime.now(),
                        'answer': uid,
                        'answerList': passages,
                      });
                      for (var e = 0; e < deletePictures.length; e++) {
                        await FirebaseStorage.instance
                            .refFromURL(passages[e])
                            .delete();
                      }
                      passages = [];
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => HomeDetail(
                            articleId: articleId,
                            askerId: askerId,
                            fromWhere: 'home',
                          ),
                          transitionDuration: const Duration(seconds: 0),
                        ),
                      );
                    },
                    child: const Text(
                      '編集する',
                      style: TextStyle(
                        color: Color(0xff0095f6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: Stack(
          children: [
            Container(
              alignment: const Alignment(0.0, 0.0),
              color: Colors.white70,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ListView.builder(
                              itemCount: passages.length,
                              itemBuilder: (BuildContext context, int index) {
                                return passages[index].length > 30
                                    ? passages[index].substring(0, 30) !=
                                            'https://firebasestorage.google'
                                        ? Container(
                                            decoration: const BoxDecoration(
                                                border: Border(
                                              left: BorderSide(
                                                color: Colors.grey,
                                                width: 5,
                                              ),
                                            )),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: RawKeyboardListener(
                                                autofocus: true,
                                                focusNode: FocusNode(),
                                                onKey: (event) {
                                                  if (event.isKeyPressed(
                                                          LogicalKeyboardKey
                                                              .backspace) &&
                                                      passages[index] == '' &&
                                                      index != 0 &&
                                                      passages[index - 1]
                                                              .length >=
                                                          30) {
                                                    if (passages[index - 1]
                                                            .substring(0, 30) !=
                                                        'https://firebasestorage.google') {
                                                      passages.removeAt(index);
                                                      setState(() {});
                                                    } else {

                                                    }
                                                  } else if (passages[index]
                                                              .length <=
                                                          30 &&
                                                      index != 0) {
                                                    passages.removeAt(index);
                                                    setState(() {});
                                                  }
                                                },
                                                child: TextField(
                                                    controller:
                                                        TextEditingController(
                                                            text: passages[
                                                                index]),
                                                    onChanged: (val) {
                                                      passages[index] = val;
                                                    },
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    maxLines: null,
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .center,
                                                    decoration:
                                                        const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            8.0),
                                                            isDense: true,
                                                            border: InputBorder
                                                                .none,
                                                            hintStyle:
                                                                TextStyle(
                                                              fontSize: 20,
                                                            ))),
                                              ),
                                            ),
                                          )
                                        : Stack(
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 15),
                                                  child: Image.network(
                                                    passages[index],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 23,
                                                right: 13,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.white,
                                                  ),
                                                  width: 30,
                                                  height: 30,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      // 写真をstorageから消す処理
                                                      deletePictures
                                                          .add(passages[index]);
                                                      // 写真をListから消す処理
                                                      passages.removeAt(index);
                                                      setState(() {});
                                                    },
                                                    child: const Icon(
                                                      Icons.close,
                                                      size: 20,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                    : Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                          left: BorderSide(
                                            color: Colors.grey,
                                            width: 5,
                                          ),
                                        )),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: RawKeyboardListener(
                                            autofocus: true,
                                            focusNode: FocusNode(),
                                            onKey: (event) {
                                              if (event.isKeyPressed(
                                                      LogicalKeyboardKey
                                                          .backspace) &&
                                                  passages[index] == '' &&
                                                  index != 0 &&
                                                  passages[index - 1].length >=
                                                      30) {
                                                if (passages[index - 1]
                                                        .substring(0, 30) !=
                                                    'https://firebasestorage.google') {
                                                  passages.removeAt(index);
                                                  setState(() {});
                                                }
                                              } else if (passages[index]
                                                          .length <=
                                                      30 &&
                                                  index != 0) {
                                                passages.removeAt(index);
                                                setState(() {});
                                              }
                                            },
                                            child: TextField(
                                                controller:
                                                    TextEditingController(
                                                        text: passages[index]),
                                                onChanged: (val) {
                                                  passages[index] = val;
                                                },
                                                keyboardType:
                                                    TextInputType.multiline,
                                                maxLines: null,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                ),
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                decoration:
                                                    const InputDecoration(
                                                        isDense: true,
                                                        border:
                                                            InputBorder.none,
                                                        hintStyle: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.grey,
                                                        ))),
                                          ),
                                        ),
                                      );
                              }),
                        ),
                      ),
                    ),
                  ]),
            ),
            Positioned(
              top: 10,
              left: 30,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                width: 70,
                height: 70,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    DatabaseService(uid).updateQuestionImage().then((value) {
                      if (value != '') {
                        passages.add(value);
                        passages.add('');
                      }
                      setState(() {});
                    });
                  },
                  child: const Icon(
                    Icons.image,
                    size: 45,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
