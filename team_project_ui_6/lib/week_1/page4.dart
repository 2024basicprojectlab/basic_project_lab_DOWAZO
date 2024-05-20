import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 메시지 없애기
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('DOWAZO')), // 타이틀 이름 변경
        ),
        body: SingleChildScrollView(
          // 이미지 목록을 보여주는 위젯 호출
          child: ImageList(),
        ),
        floatingActionButton: FloatingActionButton(
          // 우측 하단의 +동그라미 버튼
          onPressed: () {
            // 버튼을 눌렀을 때의 동작 추가
            // 새글 추가 동작 등을 여기에 구현
          },
          child: Icon(Icons.add), // 아이콘은 추가 아이콘으로 설정
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.endFloat, // 우측 하단에 위치하도록 설정
      ),
    );
  }
}

class ImageList extends StatelessWidget {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: imageUrls.map((imageUrl) {
        return Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1.0),
            // 테두리 두께와 색상 설정
            borderRadius: BorderRadius.circular(10.0), // 모서리를 둥글게 만듦
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 300.0, // 이미지의 세로 크기를 줄임
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover, // 이미지가 이미지 박스에 맞도록 조정
                  ),
                  borderRadius: BorderRadius.circular(10.0), // 모서리를 둥글게 만듦
                ),
              ),
              SizedBox(height: 10.0), // 이미지와 텍스트 사이 간격 설정
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200, // 박스 색상 설정
                  borderRadius: BorderRadius.circular(10.0), // 모서리를 둥글게 만듦
                ),
                child: Text(
                  '(게시 날짜)',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
