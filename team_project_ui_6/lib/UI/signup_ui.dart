import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_project_ui_6/Utils.dart';
import 'package:team_project_ui_6/Data/User.dart';
import 'package:team_project_ui_6/app.dart';
import 'package:team_project_ui_6/widgets/text_filed_input.dart';
import 'package:team_project_ui_6/UI/login_ui.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _IDController = TextEditingController();
  final TextEditingController _PWController = TextEditingController();
  final TextEditingController _PW2Controller = TextEditingController();
  Uint8List? _image;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _register(BuildContext context) async {
    try {
      if(_IDController.text == "") {
        showSnackBar(context);
      } else {
        QuerySnapshot snapshot = await firestore.collection("User_info")
            .where("id", isEqualTo: _IDController.text).limit(1).get();

        if (snapshot.docs.isNotEmpty || _PWController.text != _PW2Controller.text) {
          showSnackBar(context);
        } else {
          firestore.collection('User_info').doc(_IDController.text).set(
              {'id': _IDController.text, 'pw': _PWController.text});
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {print(e.toString());}
    catch(e) {print(e.toString());}
  }

  @override
  void dispose() {
    super.dispose();
    _IDController.dispose();
    _PWController.dispose();
    _PW2Controller.dispose();
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              const SizedBox(
                height: 64,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                    backgroundColor: Colors.white,
                  )
                      : const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(
                        'https://i.stack.imgur.com/l60Hf.png'),
                    backgroundColor: Colors.white,
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: '아이디',
                textInputType: TextInputType.text,
                textEditingController: _IDController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: '비밀번호',
                textInputType: TextInputType.text,
                textEditingController: _PWController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: '비밀번호 확인',
                textInputType: TextInputType.text,
                textEditingController: _PW2Controller,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              ButtonTheme(
                child: ElevatedButton(
                  onPressed: () {
                    _register(context);
                  },
                  child: Text("회원가입"),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      '계정이 있으신가요?',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' 로그인.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
