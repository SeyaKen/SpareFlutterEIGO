import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterstudeng/main_page.dart';
import 'package:flutterstudeng/services/database.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({Key? key}) : super(key: key);

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

List passages = [''];
var forSearchList = {};

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class _QuestionsScreenState extends State<QuestionsScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String caption = '';

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("わかりやすいタイトルを設定してください。"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
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
                  CupertinoButton(
                    onPressed: () {
                      showCupertinoModalPopup<void>(
                        context: context,
                        builder: (BuildContext context) => CupertinoActionSheet(
                          actions: <CupertinoActionSheetAction>[
                            CupertinoActionSheetAction(
                              child: const Text('保存せずに閉じる',
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                passages = [''];
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        MainPage(currenttab: 0),
                                    transitionDuration:
                                        const Duration(seconds: 0),
                                  ),
                                );
                              },
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            child: const Text(
                              'キャンセル',
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text('閉じる',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      // captionが2文字以上だったら
                      if (caption.length >= 2) {
                        for (int i = 0; i < caption.length - 1; i++) {
                          forSearchList[caption.substring(i, i + 2)] = true;
                          // 題名を格納し終わったら本文の格納に移る
                          if (i == caption.length - 2) {
                            // passages.lengthは文章の数
                            for (int i1 = 0; i1 < passages.length; i1++) {
                              if (passages[i1]
                                  .contains('https://firebasestorage.google')) {
                              } else {
                                for (int i2 = 0;
                                    i2 < passages[i1].length - 1;
                                    i2++) {
                                  forSearchList[passages[i1]
                                      .substring(i2, i2 + 2)] = true;
                                }
                                // 全ての処理が終わったら、データベースに格納する関数。
                                if (i1 == passages.length - 1) {
                                  FirebaseFirestore.instance
                                      .collection('questions')
                                      .doc(getRandomString(15))
                                      .set({
                                    'caption': caption,
                                    'date': DateTime.now(),
                                    'asker': uid,
                                    'questionList': passages,
                                    'answersList': [],
                                    'forSearchList': forSearchList,
                                    'like': 0,
                                  });
                                  forSearchList = {};
                                  passages = [''];
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          MainPage(currenttab: 0),
                                      transitionDuration:
                                          const Duration(seconds: 0),
                                    ),
                                  );
                                }
                              }
                            }
                          }
                        }
                      } else {
                        _showDialog(context);
                      }
                    },
                    child: const Text(
                      '公開',
                      style: TextStyle(
                        color: Color(0xff0095f6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
      body: Stack(
        children: [
          Container(
            alignment: const Alignment(0.0, 0.0),
            color: Colors.white70,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                        onChanged: (val) {
                          setState(() => caption = val);
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'タイトル',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ))),
                  ),
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
                                                            .length <=
                                                        30) {
                                                  passages.removeAt(index);
                                                  setState(() {});
                                                } else if (event.isKeyPressed(
                                                        LogicalKeyboardKey
                                                            .backspace) &&
                                                    passages[index].length >=
                                                        30 &&
                                                    index != 0) {
                                                  if (passages[index]
                                                          .substring(0, 30) !=
                                                      'https://firebasestorage.google') {
                                                    passages.removeAt(index);
                                                    setState(() {});
                                                  }
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
                                                passages[index - 1].length <=
                                                    30) {
                                              passages.removeAt(index);
                                              setState(() {});
                                            } else if (passages[index].length >=
                                                    30 &&
                                                index != 0) {
                                              if (event.isKeyPressed(
                                                      LogicalKeyboardKey
                                                          .backspace) &&
                                                  passages[index]
                                                          .substring(0, 30) !=
                                                      'https://firebasestorage.google') {
                                                passages.removeAt(index);
                                                setState(() {});
                                              }
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
                                              decoration: const InputDecoration(
                                                  isDense: true,
                                                  border: InputBorder.none,
                                                  hintStyle: TextStyle(
                                                    fontSize: 20,
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
