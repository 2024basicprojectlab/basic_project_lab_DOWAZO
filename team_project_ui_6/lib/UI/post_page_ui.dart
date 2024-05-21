import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_project_ui_6/UI/posting.dart';
import 'package:team_project_ui_6/UI/posting_comment.dart';
import 'package:team_project_ui_6/UI/serch_ui.dart';
import 'package:team_project_ui_6/Colors.dart';
import 'package:team_project_ui_6/UI/tagged_post_page_ui.dart';

import 'main_page_ui.dart';
import 'my_page.dart';


class Post_Page extends StatefulWidget {
  final String text_id;
  const Post_Page({super.key, required this.text_id});

  @override
  State<Post_Page> createState() => _Post_PageState(text_id: this.text_id);
}

class _Post_PageState extends State<Post_Page> {
  final String text_id;

  _Post_PageState({required this.text_id});

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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => My_Page())
              );
              print("Navigate My_page\n");
            },
          ),
          actions: [
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
        body: StreamBuilder<QuerySnapshot> (
          stream: FirebaseFirestore.instance.collection(text_id).snapshots(),
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
                      List<String> tag_List = List.from(document['tags']);

                      // tag_List에 tag_info가 포함되어 있는지 확인합니다.
                      return ImageItem(imageUrl: imageUrl, title: title, tagList: tag_List, text_id: text_id,);
                    }).toList(),

                  ),
                );
            }
          },

        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Posting_Comment(text_id: text_id))
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
          Image.network(imageUrl),
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
                      MaterialPageRoute(builder: (context) => Tagged_Post_Page(tag_info: tag, text_id: text_id))
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