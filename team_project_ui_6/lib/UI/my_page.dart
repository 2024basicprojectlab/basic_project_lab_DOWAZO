import 'package:flutter/material.dart';
import 'package:team_project_ui_6/UI/serch_ui.dart';
import 'package:team_project_ui_6/UI/main_page_ui.dart';
import 'package:team_project_ui_6/Colors.dart';

class My_Page extends StatefulWidget {
  const My_Page({super.key});

  @override
  State<My_Page> createState() => _My_PageState();
}

class _My_PageState extends State<My_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32),
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
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search()));
              print("Navigate Search\n");
            },
          ),
        ],
      ),
    );
  }
}
