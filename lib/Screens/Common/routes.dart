import 'package:chat_app/CustomWidget/search_user_page.dart';
import 'package:chat_app/Helpers/local_storage.dart';
import 'package:chat_app/Screens/Home/home.dart';
import 'package:chat_app/Screens/Login/login.dart';
import 'package:flutter/material.dart';

Widget initialFunction() {
  bool isLogin = LocalStorage.getString('token') != null;

  return isLogin ? const HomePage() : const LoginPage();
  // return SearchUserPage();
}

final Map<String, Widget Function(BuildContext)> namesRoutes = {
  '/': (context) => initialFunction()
};
