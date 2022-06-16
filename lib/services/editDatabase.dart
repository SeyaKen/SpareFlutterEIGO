import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class editService extends ChangeNotifier {
  final String uid;
  editService(this.uid);
  File? imageFile;
  Image? imgs;

  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('users');

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

  // 画像を処理する関数

  Future updateImage() async {
    await showImagePicker();
    await addImage();
    notifyListeners();
  }

  Future showImagePicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    imageFile = File(pickedFile!.path);
    notifyListeners();
  }

  Future addImage() async {
    final imageURL = await uploadFile();

    // firebaseに追加
    final doc =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();
    await brewCollection.doc(uid).update({
      'imageURL': FieldValue.arrayUnion([imageURL]),
    });

    CollectionReference ref =
        FirebaseFirestore.instance.collection("chatrooms");
    QuerySnapshot eventsQuery =
        await ref.where("users", arrayContains: uid).get();
    for (var msgDoc in eventsQuery.docs) {
      msgDoc.reference.update({uid: imageURL});
    }
    fetchImage();
  }

  // ファイルをアップロードする関数
  Future<String> uploadFile() async {
    if (imageFile == null) {
      return '';
    }
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('images').child(uid);

    final snapshot = await ref.putFile(
      imageFile!,
    );

    final urlDownload = await snapshot.ref.getDownloadURL();

    return urlDownload;
  }
  // 画像を処理する関数
}