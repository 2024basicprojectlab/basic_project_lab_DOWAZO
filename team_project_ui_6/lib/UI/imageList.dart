import 'package:flutter/material.dart';

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