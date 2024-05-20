import 'package:flutter/material.dart';
import 'package:team_project_ui_6/Colors.dart';
import 'package:team_project_ui_6/ImageList.dart';
import 'package:team_project_ui_6/UI/serch_ui.dart';
import 'package:team_project_ui_6/UI/posting.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
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
        centerTitle: true,
        title: const Text(
          "DOWAZO",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Navigator -> Search
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search()));
              print("Navigate Search\n");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        /////////////////////////////////////////////////////////////////////////////
        // 서버에서 데이터 가져와서 여기 body에 띄워줘야함.
        /////////////////////////////////////////////////////////////////////////////
        child: ImageList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Posting()));
          // Navigate Posting
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // 우측 하단에 위치하도록 설정
    );
  }
}
