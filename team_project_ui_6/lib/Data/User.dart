import 'package:flutter/material.dart';
import 'package:team_project_ui_6/app.dart';

class User {
  String id;
  String pw;

  User(this.id, this.pw);

  User.clone(User user)
    : this(user.id, user.pw);

  setId(String id){
    this.id = id;
  }

  setPw(String pw) {
    this.pw = pw;
  }
}