import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_project_ui_6/posting.dart';
import 'package:team_project_ui_6/search.dart';


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
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("DOWAZO"),
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
          stream: FirebaseFirestore.instance.collection('Text_info').snapshots(),
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
                      if(tag_List.contains(tag_info)) {
                        // 포함되어 있다면 ImageItem 위젯을 반환합니다.
                        return ImageItem(
                          imageUrl: imageUrl,
                          title: title,
                          tagList: tag_List,
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
  final List<String> tagList;

  ImageItem({required this.imageUrl, required this.title, required this.tagList});

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

