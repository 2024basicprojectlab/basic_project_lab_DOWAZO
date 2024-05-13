import 'package:flutter/material.dart';
import 'package:team_project_ui_6/week_1/page5.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  String searchText = ''; // 검색어
  List<String> items = ['자료구조', '확률과 통계', 'C언어', 'Python', '기초프로젝트랩', 'flutter'];
  List<String> itemContents = [
    '자료구조',
    '확률과 통계',
    'C언어',
    'Python',
    '기초프로젝트랩',
    'flutter'
  ];

  void cardClickEvent(BuildContext context, int index) {
    String content = itemContents[index];
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContentPage(content: content))
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '태그를 입력해주세요',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 9),
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {

                        });
                      },
                    ),
                  )
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                }
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 3/2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    if(searchText.isNotEmpty
                      && !items[index]
                            .toLowerCase()
                            .contains(searchText.toLowerCase())) {
                      return SizedBox.shrink();
                    }
                    else {
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.elliptical(20, 20)),
                        ),
                        child: Center(
                          child: ListTile(
                            title: ElevatedButton(
                              onPressed: () {
                                // 해당 태그로 모여있는 게시판으로
                                // Navigator -> Tagged_HomePage
                              },
                              child: Text(
                                items[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
