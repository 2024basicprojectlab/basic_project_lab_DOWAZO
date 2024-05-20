import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:team_project_ui_6/UI/main_page_ui.dart';
import 'package:team_project_ui_6/Utils.dart';
import 'package:team_project_ui_6/UI/login_ui.dart';
import 'dart:typed_data';

class Posting extends StatefulWidget {
  const Posting({super.key});

  @override
  State<Posting> createState() => _PostingState();
}

class _PostingState extends State<Posting> {
  TextEditingController _titlecontroller = TextEditingController();
  TextEditingController _tagcontroller = TextEditingController();
  List<String> _tagList = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  XFile? _image;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }

  void post(BuildContext context) async {
    try {
      if(_titlecontroller.text == "" || _tagList.length == 0 || _image == null) {
        showSnackBar(context);
      } else {
        var countQuerySnapshot = await firestore.collection('Text_info').get();
        int num = countQuerySnapshot.docs.length;
        String text_name = "${onUser!.id}_$num";

        Uint8List imageData = await _image!.readAsBytes();
        await firebaseStorage.ref('image_data/${text_name}').putData(
            imageData, SettableMetadata(contentType: "image/jpeg"));

        Reference _ref = firebaseStorage.ref('image_data/${text_name}');
        String _url = await _ref.getDownloadURL();

        firestore.collection('Text_info').doc(text_name).set(
            {'text_id': text_name, 'title':_titlecontroller.text, 'tags':_tagList, 'image_url': _url});

        for(String tag in _tagList) {
          // 'Tag_info' 컬렉션에서 해당 태그가 있는지 확인
          DocumentSnapshot tagSnapshot = await firestore.collection('Tag_info').doc(tag).get();

          // 해당 태그가 없는 경우에만 추가
          if (!tagSnapshot.exists) {
            // 'Tag_info' 컬렉션에 태그 추가
            await firestore.collection('Tag_info').doc(tag).set({});
          }
        }

        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FeedScreen())
        );
      }
    } on FirebaseAuthException catch(e) {print(e.toString());}
    catch(e) {print(e.toString());}
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? Container(
      width: 300, height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(File(_image!.path)),
        ),
      ),
      //child: Image.file(File(_image!.path)),
    )
        : Container(
      width: 300, height: 300,
      color: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('제목'), // 글 제목을 입력하는 텍스트 위젯입니다.
              TextField(
                controller: _titlecontroller,
                decoration: InputDecoration(
                  hintText: '제목을 입력해주세요',
                  border: OutlineInputBorder(),
                ),
              ),
              Text('태그'), // 글에 부여할 태그를 입력하는 텍스트 위젯입니다.
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tagcontroller,
                      decoration: InputDecoration(
                        hintText: '태그를 입력해주세요',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        String text = _tagcontroller.text;
                        if (text.isNotEmpty) {
                          setState(() {
                            _tagList.add(text);
                            _tagcontroller.clear();
                          });
                        }
                      },
                      icon: Icon(
                        Icons.send,
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: _tagList
                    .map(
                      (text) => Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.blue),
                            ),
                            child: Text(text),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _tagList.remove(text);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0.5,
                          blurRadius: 5,
                        )
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        getImage(ImageSource.camera);
                      }, // 카메라에서 이미지 한장 선택
                      icon: Icon(
                        Icons.add_a_photo,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0.5,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      }, // 갤러리에서 이미지 한장 선택
                      icon: Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              _buildPhotoArea(),
              IconButton(
                onPressed: () {
                  // 작성된 글을 올리기
                  post(context);
                },
                icon: Icon(
                  Icons.send,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
