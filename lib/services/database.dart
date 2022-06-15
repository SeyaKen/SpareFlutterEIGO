import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutterstudeng/Home/home_screen.dart';
import 'package:image_picker/image_picker.dart';

class DatabaseService extends ChangeNotifier {
  final String uid;
  DatabaseService(this.uid);
  File? imageFile;
  Image? imgs;

  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('users');

  // 質問一覧をうつす関数
  Stream<QuerySnapshot<Map<String, dynamic>>> dataCollect() {
    return FirebaseFirestore.instance
        .collection('questions')
        .orderBy('date', descending: true)
        .limit(50)
        .snapshots();
  }

  // 検索した質問一覧をうつす関数
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>?> searchDataCollect(
      searchWordsList) async {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection('questions');
    for (var i = 0; i < searchWordsList.length; i++) {
      try {
        query =
            query.where('forSearchList.${searchWordsList[i]}', isEqualTo: true);
      } catch (e) {
        // print(e.toString());
      }
      if (i == searchWordsList.length - 1) {
        return query.snapshots();
      }
    }

    return null;
  }

  // 個人的な？質問一覧をうつす関数
  Stream<QuerySnapshot<Map<String, dynamic>>> personalQuestinosCollect() {
    return FirebaseFirestore.instance
        .collection('questions')
        .orderBy('date', descending: true)
        .where('asker', isEqualTo: uid)
        .limit(50)
        .snapshots();
  }

  // 個人的な？質問一覧をうつす関数
  Stream<QuerySnapshot<Map<String, dynamic>>> personalAnsersCollect() {
    return FirebaseFirestore.instance
        .collection('questions')
        .orderBy('date', descending: true)
        .where('answersList', arrayContains: uid)
        .limit(50)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> fetchImage() async {
    return FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .snapshots();
  }

  Future updateUserName(String name) async {
    await brewCollection.doc(uid).update({
      'name': name,
    });
  }

  Future updateUserEx(String ex) async {
    await brewCollection.doc(uid).update({
      'selfIntroduction': ex,
    });
  }

  // 質問画面の画像を載せる処理
  Future updateQuestionImage() async {
    await showImagePicker();
    return await uploadQuestionFile();
  }

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<String> uploadQuestionFile() async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child(uid).child(getRandomString(15));

    try {
      final snapshot = await ref.putFile(
        imageFile!,
      );
      final urlDownload = await snapshot.ref.getDownloadURL();

      return urlDownload;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }
  // 質問画面の画像を載せる処理

  Future updateImage() async {
    await showImagePicker();
    await addImage();
    notifyListeners();
  }

  Future showImagePicker() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      imageFile = File(pickedFile!.path);
      notifyListeners();
      return imageFile;
    } catch (e) {
      print(e);
      imageFile = null;
      notifyListeners();
    }
  }

  // ファイルをアップロードする関数
  Future<String> uploadFile() async {
    if (imageFile == null) {
      return 'https://firebasestorage.googleapis.com/v0/b/studeng.appspot.com/o/44884218_345707102882519_2446069589734326272_n.jpeg?alt=media&token=aa902126-70a5-4511-a5ea-3e1d1eba2d53';
    } else {
      final storage = FirebaseStorage.instance;
      final ref = storage.ref().child(uid).child('ProfilePicture');

      final snapshot = await ref.putFile(
        imageFile!,
      );

      final urlDownload = await snapshot.ref.getDownloadURL();

      return urlDownload;
    }
  }

  Future addImage() async {
    final ProfilePicture = await uploadFile();

    // firebaseに追加
    await brewCollection.doc(uid).update({
      'ProfilePicture': ProfilePicture,
    });
    fetchImage();
  }

  Future profilePictureUpdate(DocumentSnapshot<Object?>? ds) async {
    if (ds!['ProfilePicture'] != '') {
      await FirebaseStorage.instance.refFromURL(ds['ProfilePicture']).delete();
    }
    showImagePicker().then((valu) async {
      await brewCollection
          .doc(uid)
          .update({"ProfilePicture": ds['ProfilePicture']});
    });
  }
}
