import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_project_ui_6/Data/User.dart';
import 'package:team_project_ui_6/register.dart';
import 'home_page.dart';
import 'login.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DOWAZO',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("로그인"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login())
                );
              },
            ),
            SizedBox(height: 200,),
            ElevatedButton(
              child: Text("회원가입"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register())
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
