import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_project_ui_6/UI/serch_ui.dart';
import 'package:team_project_ui_6/UI/main_page_ui.dart';
import 'package:team_project_ui_6/Colors.dart';
import 'package:team_project_ui_6/Utils.dart';
import 'package:team_project_ui_6/UI/login_ui.dart';

class My_Page extends StatefulWidget {
  const My_Page({super.key});

  @override
  State<My_Page> createState() => _My_PageState();
}

class _My_PageState extends State<My_Page> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  int post_num = 0;
  int comment_num = 0;
  bool isLoading = false;

  // postLen commentLen 가져오기
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot snapshot = await firestore
          .collection('User_info')
          .where("id", isEqualTo: onUser?.id)
          .limit(1)
          .get();

      post_num = snapshot.docs.first['post_num'];
      comment_num = snapshot.docs.first['comment_num'];

      // var postSnap = await FirebaseFirestore.instance
      //     .collection('posts')
      //     .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      //     .get();

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: Duration(seconds: 2),
      ));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedScreen()),
                  );
                },
              ),
              centerTitle: true,
              title: TextButton(
                child: const Text(
                  "DOWAZO",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedScreen()),
                  );
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Navigator -> Search
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Search()));
                    print("Navigate Search\n");
                  },
                ),
              ],
            ),
            body: ListView(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Icon(
                            Icons.account_circle,
                            size: 64,
                            color: Colors.white,
                          ),
                          radius: 40,
                        ),
                        buildStatColumn(post_num, "내가 쓴 글"),
                        buildStatColumn(comment_num, "내가 쓴 의견")
                      ],
                    ),
                    StreamBuilder<QuerySnapshot>(
                      // 나중에 stream 로그인된 계정이 쓴 글로 되게 해야함.
                      stream: FirebaseFirestore.instance
                          .collection('Text_info')
                          .where("user_id" ,isEqualTo: onUser?.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error ${snapshot.error}');
                        }

                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            return GridView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 1.5,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                DocumentSnapshot snap =
                                    (snapshot.data! as dynamic).docs[index];

                                return SizedBox(
                                  child: Image(
                                    image: NetworkImage(snap['image_url']),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

class MyPageItem extends StatelessWidget {
  final String imageUrl;

  MyPageItem({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.33,
      width: MediaQuery.of(context).size.width * 0.33,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: GestureDetector(
        child: Image.network(imageUrl),
        onTap: () {
          /*    게시글 댓글로 넘어갑니다.
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                );
                 */
        },
      ),
    );
  }
}
