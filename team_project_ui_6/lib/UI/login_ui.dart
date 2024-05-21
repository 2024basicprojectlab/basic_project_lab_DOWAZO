import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:team_project_ui_6/widgets/text_filed_input.dart';
import 'package:team_project_ui_6/Data/User.dart';
import 'package:team_project_ui_6/app.dart';
import 'package:team_project_ui_6/UI/main_page_ui.dart';
import 'package:team_project_ui_6/UI/signup_ui.dart';
import 'package:team_project_ui_6/Utils.dart';
import 'package:team_project_ui_6/Colors.dart';
import 'package:team_project_ui_6/Data/User.dart';

User_data? onUser;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _IDController = TextEditingController();
  final TextEditingController _PWController = TextEditingController();


  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _login(BuildContext context) async {
    try {
      QuerySnapshot snapshot = await firestore.collection("User_info")
          .where("id", isEqualTo: _IDController.text).limit(1).get();
      if(snapshot.docs.isNotEmpty) {
        DocumentSnapshot document = snapshot.docs.first;
        String pw = document['pw'];

        print(_PWController.text + ' --- ' + pw + '  ' + _PWController.text + '\n');

        if (pw == _PWController.text) {
          onUser = User_data(_IDController.text, _PWController.text);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FeedScreen()),
          );
          print("MOVING");
        } else {showSnackBar(context);}
      } else {showSnackBar(context);}
    } on FirebaseAuthException catch (e) {print(e.toString());}
    catch(e) {print(e.toString());}
  }

  @override
  void dispose() {
    super.dispose();
    _IDController.dispose();
    _PWController.dispose();
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
              Text(
                "DOWAZO",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 48),
              ),
              const SizedBox(
                height: 64,
              ),
              TextFieldInput(
                hintText: '아이디',
                textInputType: TextInputType.emailAddress,
                textEditingController: _IDController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: '비밀번호',
                textInputType: TextInputType.text,
                textEditingController: _PWController,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              ButtonTheme(
                child: ElevatedButton(
                  onPressed: () {
                    _login(context);
                  },
                  child: Text("로그인"),
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
                      '아직 회원이 아니신가요?',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' 회원가입.',
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
