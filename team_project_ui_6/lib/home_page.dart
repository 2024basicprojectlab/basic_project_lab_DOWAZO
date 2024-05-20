import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_project_ui_6/posting.dart';
import 'package:team_project_ui_6/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // 이미지 URL 목록
  final List<String> imageUrls = [
    'https://via.placeholder.com/150',
    'https://via.placeholder.com/200',
    'https://via.placeholder.com/250',
    'https://via.placeholder.com/300',
    'https://via.placeholder.com/350',
    'https://via.placeholder.com/400',
    // 원하는 만큼 이미지 URL 추가
  ];

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

                      return ImageItem(imageUrl: imageUrl, title: title, tagList: tag_List);
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
            children: tagList.map((tag) => Chip(label: Text(tag))).toList(),
          ),
        ],
      ),
    );
  }
}
