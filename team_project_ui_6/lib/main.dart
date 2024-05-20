import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'package:team_project_ui_6/Colors.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyCKEL1rk9UYaBtwDFKK9QtMW7KxbmPhlCc",
        authDomain: "basiclabproject.firebaseapp.com",
        projectId: "basiclabproject",
        storageBucket: "basiclabproject.appspot.com",
        messagingSenderId: "745543281476",
        appId: "1:745543281476:web:05d0e7e6f9aa2dec0bc511",
        measurementId: "G-QTSW2MD1D9"
    ),
  );

  runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'DOWAZO',
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: mobileBackgroundColor,
    ),
    home: MyApp(),
  ));
}
