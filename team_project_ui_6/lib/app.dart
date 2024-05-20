import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_project_ui_6/Data/User.dart';
// import 'home_cubit.dart';
import 'package:team_project_ui_6/UI/login_ui.dart';
import 'package:team_project_ui_6/UI/signup_ui.dart';
import 'package:team_project_ui_6/Colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DOWAZO',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "DOWAZO",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 48),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    ElevatedButton(
                      child: Text("로그인"),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                      child: Text("회원가입"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreen()));
                      },
                    ),
                  ]
                  ,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
