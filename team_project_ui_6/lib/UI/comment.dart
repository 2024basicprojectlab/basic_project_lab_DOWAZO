import 'dart:html';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:team_project_ui_6/UI/my_page.dart'; // MyPage를 위한 import (My_Page)
import 'package:team_project_ui_6/UI/post_page_ui.dart';
import 'package:team_project_ui_6/UI/search_ui.dart'; // SearchPage를 위한 import (Search)
import 'package:team_project_ui_6/UI/main_page_ui.dart';

import '../Colors.dart';
import 'login_ui.dart';

// 애플리케이션의 루트 위젯
class Comment_Page extends StatefulWidget {
  final String text_id;

  const Comment_Page({super.key, required this.text_id});

  @override
  State<Comment_Page> createState() => _Comment_PageState(text_id: text_id);
}

// 댓글 페이지를 정의한 위젯
class _Comment_PageState extends State<Comment_Page> {
  final String text_id;

  _Comment_PageState({required this.text_id});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: mobileBackgroundColor, // 배경색 설정
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          // 앱바 배경색 설정
          title: TextButton(
            child: const Text(
              "DOWAZO",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        FeedScreen()), // FeedScreen이 정의되어 있어야 합니다.
              );
            },
          ),
          centerTitle: true,
          // 앱바의 제목을 중앙에 배치
          leading: IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => My_Page()), // MyPage가 정의되어 있어야 합니다.
              );
              print("Navigate My_page\n");
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Search()), // SearchPage가 정의되어 있어야 합니다.
                );
                print("Navigate Search\n");
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(text_id)
              .orderBy('text_id', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error ${snapshot.error}');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                return SingleChildScrollView(
                  child: Column(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      String imageUrl = document['image_url'];
                      String title = document['title'];
                      print(imageUrl + "  " + title);

                      //return ImageItem(
                      return CommentItem(
                          title: title, imageUrl: imageUrl, text_id: text_id);
                    }).toList(),
                  ),
                );
            }
          },
        ),
        bottomNavigationBar: BottomAppBar(
          color: mobileBackgroundColor, // 하단 바 배경색 설정
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _showPopup(context); // 버튼 클릭 시 팝업 창을 띄움
              },
              child: Text('Add Comment'),
            ),
          ),
        ),
      ),
    );
  }

  // 팝업 창을 보여주는 함수
  void _showPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 화면의 크기 조절을 위해 추가
      builder: (BuildContext context) {
        return AddCommentForm(
          text_id: text_id,
        ); // 팝업 창에 추가할 폼을 반환
      },
    );
  }
}

// 댓글 추가 폼 위젯
class AddCommentForm extends StatefulWidget {
  final String text_id;

  const AddCommentForm({super.key, required this.text_id});

  @override
  _AddCommentFormState createState() => _AddCommentFormState(text_id: text_id);
}

class _AddCommentFormState extends State<AddCommentForm> {
  final String text_id;

  _AddCommentFormState({required this.text_id});

  final _titleController = TextEditingController(); // 제목 입력 컨트롤러

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  XFile? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }

  void post(BuildContext context) async {
    try {
      if (_titleController.text == "" || _image == null) {}
      else {
        final now = DateTime.timestamp();
        String stringDate = DateFormat("yyyyMMddhhmmss").format(now);
        String text_name = "${stringDate}_${onUser!.id}";

        Uint8List imageData = await _image!.readAsBytes();
        await firebaseStorage
            .ref('image_data/${text_name}')
            .putData(imageData, SettableMetadata(contentType: "image/jpeg"));

        Reference _ref = firebaseStorage.ref('image_data/${text_name}');
        String _url = await _ref.getDownloadURL();

        firestore.collection(text_id).doc(text_name).set({
          'text_id': text_name,
          'title': _titleController.text,
          'image_url': _url,
          'user_id': onUser?.id,
          'date': stringDate
        });

        QuerySnapshot snapshot = await firestore
            .collection('User_info')
            .where("id", isEqualTo: onUser?.id)
            .limit(1)
            .get();
        int comment_cnt = snapshot.docs.first['comment_num'];
        firestore.collection('User_info').doc(onUser?.id).update({
          'comment_num': comment_cnt + 1,
        });
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5, // 화면의 절반 높이
      padding: EdgeInsets.all(16.0), // 내부 패딩 설정
      decoration: BoxDecoration(
        color: Colors.white, // 배경색을 흰색으로 설정
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0), // 상단 좌측 모서리를 둥글게 설정
          topRight: Radius.circular(20.0), // 상단 우측 모서리를 둥글게 설정
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
        children: [
          Text(
            'Add a Comment',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20), // 간격 추가
          TextField(
            controller: _titleController, // 제목 입력 필드
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20), // 간격 추가
          ElevatedButton(
              child: const Text(
                '갤러리',
                textAlign: TextAlign.center,
              ),
              onPressed: () async {
                _pickImage();
              }),
          SizedBox(height: 20), // 간격 추가
          ElevatedButton(
            onPressed: () {
              post(context);

              // 버튼 클릭 시 실행될 기능 (현재는 콘솔 출력)
              Navigator.pop(context); // 팝업 창 닫기
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedScreen()),
              );
            },
            child: Text('Add Comment'),
          ),
        ],
      ),
    );
  }
}

// 개별 댓글 항목을 표시하는 위젯
class CommentItem extends StatefulWidget {
  final String title; // 댓글 제목
  final String imageUrl; // 이미지 URL
  final String text_id;

  CommentItem(
      {required this.title, required this.imageUrl, required this.text_id});

  @override
  _CommentItemState createState() =>
      _CommentItemState(title: title, imageUrl: imageUrl, text_id: text_id);
}

class _CommentItemState extends State<CommentItem> {
  bool _showImage = false; // 이미지 표시 여부
  final String title;
  final String imageUrl;
  final String text_id;

  _CommentItemState(
      {required this.title, required this.imageUrl, required this.text_id});

  void _toggleImage() {
    setState(() {
      _showImage = !_showImage; // 이미지 표시 여부 토글
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleImage, // 댓글 항목 클릭 시 이미지 토글
      child: Container(
        width: double.infinity,

        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300], // 댓글 상자 배경색을 회색으로 설정
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // 왼쪽 정렬
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (_showImage) // _showImage가 true일 때만 이미지 표시
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: AspectRatio(
                  aspectRatio: 3 / 2, // 가로:세로 비율을 3:2로 설정
                  child: Image.network(
                    imageUrl,
                    width: double.infinity, // 가로 길이를 박스의 가로 길이에 맞춤
                    fit: BoxFit.cover, // 이미지 크기를 박스의 가로 길이에 맞게 조정
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}