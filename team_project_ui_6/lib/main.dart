import 'package:flutter/material.dart';
import 'app.dart';
import 'package:team_project_ui_6/Colors.dart';

void main() {
  //runApp(MyApp());
  runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'DOWAZO',
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: mobileBackgroundColor,
    ),
    //home: Test(),
    home: MyApp(),
  ));
}
