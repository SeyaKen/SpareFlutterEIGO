import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterstudeng/HomeDetail/home_detail.dart';
import 'package:flutterstudeng/services/database.dart';

class AnswerScreen extends StatefulWidget {
  AnswerScreen({Key? key, required this.articleId, required this.askerId})
      : super(key: key);
  String articleId, askerId;

  @override
  State<AnswerScreen> createState() => _AnswerScreenState(articleId, askerId);
}

List passages = [''];
late List AnswerLists;

class _AnswerScreenState extends State<AnswerScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String articleId, askerId;
  _AnswerScreenState(this.articleId, this.askerId);
  DocumentSnapshot? answersSnapshot;

  Future InAdvance() async {
    answersSnapshot = await FirebaseFirestore.instance
        .collection('questions')
        .doc(articleId)
        .get();

    AnswerLists = answersSnapshot!.get('answersList');

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
                    passages = [''];
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black,
                  ),
                ),
                InkWell(
                  onTap: () {
                    //ここにAnswerListsの内容を変更？する処理
                    AnswerLists.add(uid);
                    FirebaseFirestore.instance
                        .collection('questions')
                        .doc(articleId)
                        .update({
                      'answersList': AnswerLists,
                    });
                    FirebaseFirestore.instance
                        .collection('questions')
                        .doc(articleId)
                        .collection('answers')
                        .doc(uid)
                        .set({
                      'date': DateTime.now(),
                      'answer': uid,
                      'answerList': passages,
                    });
                    passages = [''];
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
                    '回答する',
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
                                                    passages[index - 1]
                                                            .length >=
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
                                                          text:
                                                              passages[index]),
                                                  onChanged: (val) {
                                                    passages[index] = val;
                                                  },
                                                  keyboardType: TextInputType
                                                      .multiline,
                                                  maxLines: null,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  decoration:
                                                      const InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                          isDense: true,
                                                          border:
                                                              InputBorder.none,
                                                          hintStyle: TextStyle(
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15),
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
                                                      BorderRadius.circular(20),
                                                  color: Colors.white,
                                                ),
                                                width: 30,
                                                height: 30,
                                                child: InkWell(
                                                  onTap: () async {
                                                    // 写真をstorageから消す処理
                                                    await FirebaseStorage
                                                        .instance
                                                        .refFromURL(
                                                            passages[index])
                                                        .delete();
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
                                            } else if (passages[index].length <=
                                                    30 &&
                                                index != 0) {
                                              passages.removeAt(index);
                                              setState(() {});
                                            }
                                          },
                                          child: TextField(
                                              controller: TextEditingController(
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
                                              decoration: InputDecoration(
                                                  isDense: true,
                                                  border: InputBorder.none,
                                                  hintText: index == 0
                                                      ? 'ここに回答をお書きください。'
                                                      : '',
                                                  hintStyle: const TextStyle(
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
      ),
    );
  }
}
