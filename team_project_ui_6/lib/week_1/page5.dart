import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// 검색어
String searchText = '';

// 리스트뷰에 표시할 내용
List<String> items = ['자료구조', '확률과 통계', 'C언어', 'Python', '기초프로젝트랩', 'flutter'];
List<String> itemContents = [
  '자료구조',
  '확률과 통계',
  'C언어',
  'Python',
  '기초프로젝트랩',
  'flutter'
];

// 검색을 위해 앱의 상태를 변경해야하므로 StatefulWidget 상속
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

// 메인 클래스의 상태 상속
class MyAppState extends State<MyApp> {
  // 리스트뷰 카드 클릭 이벤트 핸들러
  void cardClickEvent(BuildContext context, int index) {
    String content = itemContents[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        // 정의한 ContentPage의 폼 호출
        builder: (context) => ContentPage(content: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'searchspace', // 앱의 아이콘 이름
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
             // 앱 상단바 설정
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '태그를 입력해주세요.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 9),
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: (){
                        setState(() {});
                      },
                    ),
                  )
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
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
                  // items 변수에 저장되어 있는 모든 값 출력
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    // 검색 기능, 검색어가 있을 경우
                    if (searchText.isNotEmpty &&
                        !items[index]
                            .toLowerCase()
                            .contains(searchText.toLowerCase())) {
                      return SizedBox.shrink();
                    }
                    // 검색어가 없을 경우, 모든 항목 표시
                    else {
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.elliptical(20, 20))),
                        child: Center(
                          child: ListTile(
                            title: Text(
                              items[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
           )
          ],
        ),
      ),
    );
  }
}

// 선택한 항목의 내용을 보여주는 추가 페이지
class ContentPage extends StatelessWidget {
  final String content;

  const ContentPage({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Content'),
      ),
      body: Center(
        child: Text(content),
      ),
    );
  }
}