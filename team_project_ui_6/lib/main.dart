import 'package:flutter/material.dart';
import 'app.dart';
import 'login.dart';

void main() {
  //runApp(MyApp());
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'NAVI',
    theme: ThemeData(primarySwatch: Colors.deepOrange),
    //home: Test(),
    home: MyApp(),
  ));
}
