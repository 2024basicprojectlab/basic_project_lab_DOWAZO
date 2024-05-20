import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_project_ui_6/UI/tagged_page.dart';
import 'package:team_project_ui_6/week_1/page5.dart';

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

                return ListView.builder(
                  itemCount: matchedTags.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {  },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ButtonTheme(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Tagged_Page(tag_info: matchedTags[index]))
                              );
                            },
                            child: Text(matchedTags[index]),
                          ),
                        ),
                      ),
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
