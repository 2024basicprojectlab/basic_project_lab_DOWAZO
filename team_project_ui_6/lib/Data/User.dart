import 'package:flutter/material.dart';
import 'package:team_project_ui_6/app.dart';

class User_data {
  String id;
  String pw;

  User_data(this.id, this.pw);

  User_data.clone(User_data user)
      : this(user.id, user.pw);

  setId(String id){
    this.id = id;
  }

  setPw(String pw) {
    this.pw = pw;
  }
}