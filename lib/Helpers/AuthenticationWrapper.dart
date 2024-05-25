import 'package:chat_app/Screens/Message/chat.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/Screens/Home/home.dart';
import 'package:chat_app/Screens/Login/login.dart';


class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // 在这里检查用户是否已登录，可以根据自己的逻辑进行判断
    bool isLoggedIn = false;
    if (isLoggedIn) {
      return const HomePage();
    } else {
      // return const LoginPage();
      return Chat();
    }
  }
}