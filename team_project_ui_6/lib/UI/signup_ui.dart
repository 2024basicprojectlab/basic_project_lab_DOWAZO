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

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _register(BuildContext context) async {
    try {
      if (_IDController.text == "") {
        showSnackBar(context);
      } else {
        QuerySnapshot snapshot = await firestore
            .collection("User_info")
            .where("id", isEqualTo: _IDController.text)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty ||
            _PWController.text != _PW2Controller.text) {
          showSnackBar(context);
        } else {
          firestore.collection('User_info').doc(_IDController.text).set({
            'id': _IDController.text,
            'pw': _PWController.text,
            'post_num': 0,
            'comment_num': 0
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _IDController.dispose();
    _PWController.dispose();
    _PW2Controller.dispose();
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
              CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Colors.white,
                ),
                radius: 40,
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
