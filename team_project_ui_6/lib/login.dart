import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:team_project_ui_6/Data/User.dart';
import 'package:team_project_ui_6/app.dart';
import 'package:team_project_ui_6/register.dart';

import 'home_page.dart';

User? onUser;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController controller_id = TextEditingController();
  TextEditingController controller_pw = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

