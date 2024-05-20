import 'dart:ui';
import 'package:team_project_ui_6/widgets/text_filed_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _idController.dispose();
    _pwController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Container(),
                flex: 1,
              ),
              SvgPicture.asset(
                'assets/activity.svg',
                color: Colors.black,
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              TextFieldInput(
                  textEditingController: _idController,
                  hintText: '아이디',
                  textInputType: TextInputType.text),
              const SizedBox(
                height: 20,
              ),
              TextFieldInput(
                  textEditingController: _pwController,
                  hintText: '비밀번호',
                  isPass: true,
                  textInputType: TextInputType.text),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                child: Container(
                  child: const Text('로그인'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      )),
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text('아직 회원이 아니신가요?'),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      child: const Text(
                        '회원가입',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
