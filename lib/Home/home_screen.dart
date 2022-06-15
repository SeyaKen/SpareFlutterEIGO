import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterstudeng/HomeDetail/home_detail.dart';
import 'package:flutterstudeng/Questions/questions_screen.dart';
import 'package:flutterstudeng/services/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  Stream<QuerySnapshot<Object?>>? questionsListsStream, searchStateStream;

  getHomeLists() async {
    questionsListsStream = DatabaseService(uid).dataCollect();
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
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 100,
          backgroundColor: const Color(0xfffafafa),
          elevation: 0,
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Container(
                  height: MediaQuery.of(context).size.width * 0.1,
                  width: MediaQuery.of(context).size.width * 0.95,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey[300],
                  ),
                  child: TextField(
                      onChanged: (text) async {
                        List preForSearch = [];
                        if (text.length > 1) {
                          for (int i = 0; i < text.length - 1; i++) {
                            if(!preForSearch.contains(text.substring(i, i + 2))){
                            preForSearch.add(text.substring(i, i + 2));
                            }
                          }
                          searchStateStream = await DatabaseService(uid)
                              .searchDataCollect(preForSearch);
                          setState(() {});
                        } else {
                          searchStateStream = null;
                          setState(() {});
                        }
                      },
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                        fontSize: 19,
                      ),
                      decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            size: 19,
                          ),
                          isDense: true,
                          border: InputBorder.none,
                          hintText: '検索',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 19,
                          ))),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          )),
      body: StreamBuilder<QuerySnapshot>(
          stream: searchStateStream ?? questionsListsStream,
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
                                fromWhere: 'home',
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
                : const Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
            width: 4,
          ),
        ),
        width: 60,
        height: 60,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const QuestionsScreen(),
                  transitionDuration: const Duration(seconds: 0),
                ));
          },
          child: const Icon(
            Icons.add,
            size: 50,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
