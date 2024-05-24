import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_project_ui_6/UI/tagged_page.dart';
import 'package:team_project_ui_6/week_1/page5.dart';
import 'package:team_project_ui_6/Colors.dart';
import 'package:team_project_ui_6/UI/main_page_ui.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searchText = ''; // 검색어

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text(
          "DOWAZO",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
                decoration: InputDecoration(
                    hintText: '태그를 입력해주세요',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 9),
                      child: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {});
                        },
                      ),
                    )),
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                }),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Tag_info').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              // Firestore에서 문서 이름을 가져와서 리스트로 변환
              List<String> tagList = snapshot.data!.docs.map((DocumentSnapshot document) {
                return document.id; // 문서 이름을 태그로 사용
              }).toList();

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal, // 좌우 스크롤 가능하게 설정
                child: Row(
                  children: tagList.map((tag) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Tagged_Page(tag_info: tag)),
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
                              tag,
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Tag_info').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<String> tagInfoList = [];
                for (var doc in snapshot.data!.docs) {
                  tagInfoList.add(doc.id);
                }

                List<String> matchedTags = tagInfoList.where((tag) => tag.contains(searchText)).take(9).toList();

                return LayoutBuilder(
                  builder: (context, constraints) {
                    double width = constraints.maxWidth;
                    int crossAxisCount = (width / 300).round(); // 각 열의 최소 너비를 300으로 설정

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 2, // 각 행 사이의 간격
                        crossAxisSpacing: 2, // 각 열 사이의 간격
                        childAspectRatio: 3, // 버튼의 가로 세로 비율을 설정
                      ),
                      itemCount: min(matchedTags.length, 8),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {  },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                minimumSize: Size(100, 40), // 버튼의 최소 크기를 설정
                                textStyle: TextStyle(fontSize: 18), // 텍스트 스타일 설정
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Tagged_Page(tag_info: matchedTags[index])),
                                );
                              },
                              child: Text(matchedTags[index]),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
