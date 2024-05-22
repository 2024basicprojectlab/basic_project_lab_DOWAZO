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
import 'package:team_project_ui_6/Colors.dart';
import 'package:intl/intl.dart';

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

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text(
            '이미지 올리기',
            textAlign: TextAlign.center,
          ),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  '카메라',
                  textAlign: TextAlign.center,
                ),
                onPressed: () async {
                  getImage(ImageSource.camera);
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  '갤러리',
                  textAlign: TextAlign.center,
                ),
                onPressed: () async {
                  getImage(ImageSource.gallery);
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text(
                "취소",
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void post(BuildContext context) async {
    try {
      if (_titlecontroller.text == "" ||
          _tagList.length == 0 ||
          _image == null) {
        showSnackBar(context);
      } else {
        var countQuerySnapshot = await firestore.collection('Text_info').get();
        //int num = countQuerySnapshot.docs.length;
        final now = DateTime.timestamp();
        String stringDate = DateFormat("yyyyMMddhhmmss").format(now);
        print("test중입니다" + stringDate);
        String text_name = "${stringDate}_${onUser!.id}";

        Uint8List imageData = await _image!.readAsBytes();
        await firebaseStorage.ref('image_data/${text_name}').putData(
            imageData, SettableMetadata(contentType: "image/jpeg"));

        Reference _ref = firebaseStorage.ref('image_data/${text_name}');
        String _url = await _ref.getDownloadURL();

        firestore.collection('Text_info').doc(text_name).set(
            {'text_id': text_name, 'title':_titlecontroller.text,
              'tags':_tagList, 'image_url': _url, 'user_id': onUser?.id, 'data': stringDate});


        QuerySnapshot snapshot = await firestore.collection('User_info')
            .where("id", isEqualTo: onUser?.id).limit(1).get();
        int post_cnt = snapshot.docs.first['post_num'];
        firestore.collection('User_info').doc(onUser?.id).update({
          'post_num': post_cnt+1,
        });

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

  // void clearImage() {
  //   setState(() {
  //     _image = null;
  //   });
  // }

  Widget _buildPhotoArea() {
    return _image != null
        ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(File(_image!.path)),
              ),
            ),
            //child: Image.file(File(_image!.path)),
          )
        : Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    _selectImage(context);
                  },
                  icon: Icon(
                    Icons.add_a_photo,
                    size: MediaQuery.of(context).size.width * 0.1,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        shape: Border(bottom: BorderSide(color: Colors.white, width: 1)),
        // 있는게 더 괜찮나..?
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
          TextButton(
            onPressed: () =>
                // 작성된 글을 올리기
                post(context),
            child: const Text(
              "Post",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '제목',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _titlecontroller,
                decoration: InputDecoration(
                  hintText: '제목을 입력해주세요',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '태그',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
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
                    flex: 9,
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
                        Icons.add,
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
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
              _buildPhotoArea(),
            ],
          ),
        ),
      ),
    );
  }
}
