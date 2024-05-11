import 'package:flutter/material.dart';
import 'dart:io'; // 파일 I/O를 위해 import합니다.
import 'package:image_picker/image_picker.dart'; // 이미지 피커를 사용하기 위해 import합니다.

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

final picker = ImagePicker(); // 이미지 피커를 초기화합니다.
List<XFile?> images = []; // 이미지 목록을 저장할 리스트입니다.

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('제목'), // 글 제목을 입력하는 텍스트 위젯입니다.
                TextField(
                  controller: new TextEditingController(),
                  decoration: InputDecoration(
                    hintText: '제목을 입력해주세요',
                    border: OutlineInputBorder(),
                  ),
                ),
                Text('태그'), // 글에 부여할 태그를 입력하는 텍스트 위젯입니다.
                TextField(
                  controller: new TextEditingController(),
                  decoration: InputDecoration(
                    hintText: '태그를 입력해주세요',
                    border: OutlineInputBorder(),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(5),
                      color: Colors.green,
                      child: Text("TAG 1"), // 태그 1을 나타내는 컨테이너입니다.
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(5),
                      color: Colors.green,
                      child: Text("TAG 2"), // 태그 2을 나타내는 컨테이너입니다.
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(5),
                      color: Colors.green,
                      child: Text("TAG 3"), // 태그 3을 나타내는 컨테이너입니다.
                    ),
                  ],
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
                        onPressed: () async {
                          XFile? image = await picker.pickImage(source: ImageSource.camera);
                          // 카메라에서 이미지를 선택합니다.
                          if (image != null) {
                            setState(() {
                              images.add(image); // 선택한 이미지를 리스트에 추가합니다.
                            });
                          }
                        },
                        icon: Icon(Icons.add_a_photo, size: 30, color: Colors.white,),
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
                        onPressed: () async {
                          List<XFile>? multiImage = await picker.pickMultiImage();
                          // 갤러리에서 여러 이미지를 선택합니다.
                          if (multiImage != null) {
                            setState(() {
                              images.addAll(multiImage); // 선택한 여러 이미지를 리스트에 추가합니다.
                            });
                          }
                        },
                        icon: Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: GridView.builder(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemCount: images.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1 / 1,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            // 이미지 표시
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(File(images[index]!.path)), // 이미지 파일을 가져와서 표시합니다.
                              ),
                            ),
                          ),
                          Container(
                            // 삭제 버튼
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: Icon(Icons.close, color: Colors.white, size: 15),
                              onPressed: () {
                                setState(() {
                                  images.removeAt(index); // 이미지를 삭제합니다.
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // 작성된 글을 올리기
                  },
                  icon: Icon(Icons.send,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
