import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '초기 로그인 화면'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: CustomCard(),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 프로필 이미지를 보여주는 부분
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blueGrey, width: 5),
              color: Colors.white,
            ),
            child: ClipOval(
              child: Image.network(
                '이미지 URL 여기에 입력',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 40),
          // 로그인 버튼
          Container(
            width: 200,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton(
              onPressed: () {
                // 로그인 기능 추가
              },
              child: Text(
                '로그인',
                style: TextStyle(fontSize: 36, color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 20),
          // 회원가입 버튼
          Container(
            width: 200,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton(
              onPressed: () {
                // 회원가입 기능 추가
              },
              child: Text(
                '회원가입',
                style: TextStyle(fontSize: 36, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
