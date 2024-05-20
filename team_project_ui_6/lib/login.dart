import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:team_project_ui_6/Data/User.dart';
import 'package:team_project_ui_6/app.dart';
import 'package:team_project_ui_6/register.dart';

import 'home_page.dart';

User_data? onUser;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController controller_id = TextEditingController();
  TextEditingController controller_pw = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _login(BuildContext context) async {
    try {
      QuerySnapshot snapshot = await firestore.collection("User_info")
          .where("id", isEqualTo: controller_id.text).limit(1).get();
      print("AA");
      if(snapshot.docs.isNotEmpty) {
        DocumentSnapshot document = snapshot.docs.first;
        String pw = document['pw'];

        print(controller_id.text + ' --- ' + pw + '  ' + controller_pw.text + '\n');

        if (pw == controller_pw.text) {
          onUser = User_data(controller_id.text, controller_pw.text);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
          print("MOVING");
        } else {showSnackBar(context);}
      } else {showSnackBar(context);}
    } on FirebaseAuthException catch (e) {print(e.toString());}
    catch(e) {print(e.toString());}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.deepOrange,
      body: Center(
        child: Builder(builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 130, bottom: 100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    child: Theme(
                      data: ThemeData(
                        primaryColor: Colors.deepPurple,
                        inputDecorationTheme: InputDecorationTheme(
                          labelStyle: TextStyle(
                            color: Colors.grey, fontSize: 13
                          )
                        )
                      ),
                      child: Container(
                        padding: EdgeInsets.all(40),
                        child: Column(children: [
                          Container(
                            width: 355, height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0, bottom: 3),
                              child: TextField(
                                controller: controller_id,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '아이디',
                                  hintStyle: const TextStyle(
                                    color: Color(0xb3252532),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "NotoSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15.0,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: 355, height: 50,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(50)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0, bottom: 3),
                              child: TextField(
                                controller: controller_pw,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '비밀번호',
                                  hintStyle: const TextStyle(
                                    color: Color(0xb3252532),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "NotoSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15.0,
                                  ),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                              ),
                            ),
                          ),
                          SizedBox(height: 50,),
                          ButtonTheme(
                            child: ElevatedButton(
                              onPressed: () {
                                _login(context);
                                /*
                                users.forEach((user) {
                                  if(user.id == controller_id.text
                                      && user.pw == controller_pw.text) {
                                    setState(() {
                                      onUser = User.clone(user);
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage())
                                    );
                                  } else {
                                    showSnackBar(context);
                                  }
                                });
                                 */
                              },
                              child: Text("로그인"),
                            ),
                          ),
                          SizedBox(height: 30,),
                          ButtonTheme(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Register())
                                );
                              },
                              child: Text("회원가입"),
                            ),
                          ),
                        ],),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },),
      ),
    );
  }

  void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          '올바른 정보를 입력해주세요',
          textAlign: TextAlign.center,
        ),
      duration: Duration(seconds: 2),
    ));
  }
}

