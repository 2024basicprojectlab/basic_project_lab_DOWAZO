import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:team_project_ui_6/UI/comment.dart';
import 'package:team_project_ui_6/UI/post_page_ui.dart';
import 'package:team_project_ui_6/UI/posting.dart';
import 'package:team_project_ui_6/UI/search_ui.dart';
import 'package:team_project_ui_6/Colors.dart';

import 'main_page_ui.dart';


class Tagged_Page extends StatefulWidget {
  final String tag_info;
  const Tagged_Page({super.key, required this.tag_info});

  @override
  State<Tagged_Page> createState() => _Tagged_PageState(tag_info: this.tag_info);
}

class _Tagged_PageState extends State<Tagged_Page> {
  final String tag_info;

  _Tagged_PageState({required this.tag_info});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: mobileBackgroundColor,
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextButton(
            child: const Text(
              "DOWAZO",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedScreen()),
              );
            },
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Navigator -> My_Page
              /*
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => My_Page())
              );
               */
              print("Navigate My_page\n");
            },
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Icon(Icons.videogame_asset),
              ),
              iconSize: 28,
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Navigator -> Search
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Search())
                );
                print("Navigate Search\n");
              },
            ),
          ],
        ),
        body: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Text_info').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                // Firestore에서 문서 이름을 가져와서 리스트로 변환
                List<String> idList = snapshot.data!.docs.map((DocumentSnapshot document) {
                  return document['text_id'] as String; // 문서 이름을 태그로 사용
                }).toList();

                List<String> titleList = snapshot.data!.docs.map((DocumentSnapshot document) {
                  return document['title'] as String;
                }).toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // 좌우 스크롤 가능하게 설정
                  child: Row(
                    children: idList.map((text_id) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Comment_Page(text_id: text_id,)),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple, // 네모 컨테이너의 배경색 설정
                              borderRadius: BorderRadius.circular(10), // 네모에 둥근 모서리 설정
                            ),
                            child: Center(
                              child: Text(
                                titleList[idList.indexOf(text_id)],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot> (
                stream: FirebaseFirestore.instance.collection('Text_info').orderBy("data", descending: true).snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasError) {
                    return Text('Error ${snapshot.error}');
                  }

                  switch(snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      return SingleChildScrollView(
                        child: Column(
                          children: snapshot.data!.docs.map((DocumentSnapshot document) {
                            String imageUrl = document['image_url'];
                            String title = document['title'];
                            String text_id = document['text_id'];
                            List<String> tag_List = List.from(document['tags']);

                            // tag_List에 tag_info가 포함되어 있는지 확인합니다.
                            if(tag_List.contains(tag_info)) {
                              // 포함되어 있다면 ImageItem 위젯을 반환합니다.
                              return ImageItem(
                                imageUrl: imageUrl,
                                title: title,
                                tagList: tag_List,
                                text_id: text_id,
                              );
                            } else {
                              // 포함되어 있지 않다면 빈 Container를 반환합니다.
                              return Container();
                            }
                          }).toList(),

                        ),
                      );
                  }
                },

              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Posting())
            );
            // Navigate Posting
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class ImageItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String text_id;
  final List<String> tagList;

  ImageItem({required this.imageUrl, required this.title, required this.tagList, required this.text_id});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10,),
          GestureDetector(
            child: Image.network(imageUrl),
            onTap: () {
              //    게시글 댓글로 넘어갑니다.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Comment_Page(text_id: text_id)),
              );
            },
          ),
          SizedBox(height: 10,),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: tagList.map((tag) => Chip(label:
            ButtonTheme(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Tagged_Page(tag_info: tag))
                  );
                },
                child: Text(tag),
              ),
            ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
